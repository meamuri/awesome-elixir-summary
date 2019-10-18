defmodule AwesomeTable.StarsCheckingWorker do
  require Logger

  @interval_between_execution_in_millis 5

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(_) do
    latest_request = AwesomeTable.Requests.latest_request()
    libs = get_libraries(latest_request, 0)
            |> Enum.group_by(fn e -> e.stars >= 0 end)
    state = %{
      loaded: libs[true],
      updated: libs[false],
      request_id: latest_request,
      execution_start_time: Time.utc_now,
    }
    schedule_work()
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    map_with_stars = fn record ->
      repo_stars = AwesomeTable.GithubRepositoryApi.repo_stars(record)
      %{record | stars: repo_stars}
    end

    updated = state.loaded
              |> Enum.take(5)
              |> Enum.map(&map_with_stars/1)
              |> Enum.group_by(fn e -> e.id end)

    loaded = state.loaded |> Enum.drop_by(fn e -> Map.has_key?(updated, e.id) end)
    updated = [state.updated | Enum.each(updated, fn {k, [e, _]} -> e end)]
    after_processing_ts = Time.utc_now
    delay = compute_delay(state.execution_start_time, after_processing_ts)

    schedule_work(delay)
    {:noreply, %{
      loaded: loaded,
      updated: updated,
      execution_start_time: after_processing_ts
    }}
  end

  defp get_libraries({:new, record}, lower_boundary) do
    res = AwesomeTable.Libraries.Aggregator.aggregate
          |> Enum.map(fn lib -> put_in(lib, [:request_id], record.id) end)
    Enum.filter(res, fn lib -> lib.stars >= lower_boundary end)
  end

  defp get_libraries({:from_db, record}, lower_boundary) do
    AwesomeTable.Libraries.list_with_stars_filter(lower_boundary, record.id)
  end

  defp schedule_work(delay_in_millis \\ 0) do
    Process.send_after(self(), :work, delay_in_millis)
  end

  defp compute_delay(start_execution, finished_execution) do
    delay = Time.diff(finished_execution, start_execution, :millisecond)
    with delta <- (@interval_between_execution_in_millis - delay) do
      cond do
        delta < 0 -> 0
        true -> delta
      end
    end
  end

end

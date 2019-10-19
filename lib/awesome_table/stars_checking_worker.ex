defmodule AwesomeTable.StarsCheckingWorker do
  require Logger

  @interval_between_execution_in_millis 5

  def start_link(initial \\ %{}) do
    GenServer.start_link(__MODULE__, initial)
  end

  @impl true
  def init(_) do
    schedule_work()
    {:ok, %{execution_start_time: Time.utc_now}}
  end

  @impl true
  def handle_info(:work, initial_state) do
    state = compute_state(initial_state)
    map_with_stars = fn record ->
      repo_stars = AwesomeTable.GithubRepositoryApi.repo_stars(record)
      %{record | stars: repo_stars}
    end
    Logger.info("loaded before processing: #{inspect(state.loaded)}")
    updated = state.loaded
              |> Enum.take(5)
              |> Enum.map(map_with_stars)
              |> Enum.group_by(fn e -> e.id end)

    loaded = state.loaded |> Enum.drop(fn e -> Map.has_key?(updated, e.id) end)
    Logger.info "For future updates #{inspect(loaded)}"
    updated = [state.updated | Enum.each(updated, fn {_, [e, _]} -> e end)]
    Logger.info "to update #{inspect(updated)}"
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
    res |> Enum.each(fn e -> AwesomeTable.Libraries.create_library(e) end)
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

  defp compute_state(initial_state) do
    latest_request = AwesomeTable.Requests.latest_request()
    Logger.info("latest request is #{inspect(latest_request)}")
    libs = get_libraries(latest_request, 0)
            |> Enum.group_by(fn e -> e.stars >= 0 end)
    Logger.info("init job with #{inspect(libs)}")
    state = %{
      loaded: libs[false],
      updated: libs[true],
      request_id: latest_request,
      execution_start_time: initial_state.execution_start_time,
    }
    state
  end

end
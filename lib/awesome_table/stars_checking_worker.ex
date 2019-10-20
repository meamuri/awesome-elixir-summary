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
    updated = state.loaded
              |> Enum.take(5)
              |> Enum.map(&map_with_stars/1)
              |> Enum.reduce(%{}, fn e, acc -> put_in(acc, [e.id], e) end)

    loaded = state.loaded |> Enum.filter(fn e -> !Map.has_key?(updated, e.id) end)
    Logger.info "For future updates #{inspect(loaded |> Enum.map(fn e -> e.id end))}"
    Logger.info "Updated at iteration #{inspect(Map.keys(updated))}"
    updated = state.updated ++ Map.values(updated)
    after_processing_ts = Time.utc_now
    delay = compute_delay(state.execution_start_time, after_processing_ts)

    schedule_work(delay)
    {:noreply, %{
      loaded: loaded,
      updated: updated,
      execution_start_time: after_processing_ts
    }}
  end

  defp map_with_stars(record) do
    repo_stars = AwesomeTable.GithubRepositoryApi.repo_stars(record)
    Logger.info "stars: #{inspect(repo_stars)}"
    res = %{record | stars: repo_stars}
    {status, change_set} = AwesomeTable.Libraries.update_library(record, %{stars: res.stars})
    Logger.info "update library return status #{inspect(status)}"
    Logger.info "changeset is #{inspect(change_set)}"
    change_set
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
    loaded = if libs[false], do: libs[false], else: []
    updated = if libs[true], do: libs[true], else: []
    state = %{
      loaded: loaded,
      updated: updated,
      request_id: latest_request,
      execution_start_time: initial_state.execution_start_time,
    }
    state
  end

end

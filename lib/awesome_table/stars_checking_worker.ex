defmodule AwesomeTable.StarsCheckingWorker do
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(_) do
    schedule_work()
    latest_request = AwesomeTable.Requests.latest_request()
    libs = get_libraries(latest_request, 0)
#         |> Enum.sort_by(fn e -> e.title end)
         |> Enum.group_by(fn e -> e.id end)
#         |> Enum.sort_by(fn {k, _} -> k end)
    state = %{
      libs: libs,
      updated: %{},
      request_id: latest_request,
    }
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    # Do the desired work here
    # ...

    # Reschedule once more
    schedule_work()

    before_work_ids = Map.keys(state.updated)

    updated = AwesomeTable.Libraries.list_with_stars_filter(state.request_id)
              |> Enum.map(AwesomeTable.GithubRepositoryApi.repo_stars())
              |> Enum.group_by(fn e -> e.id end)

    state.updated
      |> Enum.filter(fn {id, e} -> !Map.has_key?(updated, id) end)
      |> Enum.each(fn {k, v} ->
                        Logger.info "#{inspect v}}"
                        AwesomeTable.Libraries.update_library(%{stars: v.stars})
                   end)

    {:noreply, %{state | updated: updated}}
  end

  defp get_libraries({:new, record}, lower_boundary) do
    res = AwesomeTable.Libraries.Aggregator.aggregate
          |> Enum.map(fn lib -> put_in(lib, [:request_id], record.id) end)
    Enum.filter(res, fn lib -> lib.stars >= lower_boundary end)
  end

  defp get_libraries({:from_db, record}, lower_boundary) do
    AwesomeTable.Libraries.list_with_stars_filter(lower_boundary, record.id)
  end

  defp schedule_work do
    # In 2 secs
    Process.send_after(self(), :work, 2 * 1000)
  end

end

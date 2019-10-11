defmodule AwesomeTable.StarsCheckingWorker do

  @impl true
  def init(_) do
    state = get_libraries(AwesomeTable.Requests.latest_request(), 0)
#         |> Enum.sort_by(fn e -> e.title end)
#         |> Enum.group_by(fn e -> e.category end)
#         |> Enum.sort_by(fn {k, _} -> k end)
    {:ok, state}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  defp get_libraries({:new, record}, lower_boundary) do
    res = AwesomeTable.Libraries.Aggregator.aggregate
          |> Enum.map(fn lib -> put_in(lib, [:request_id], record.id) end)
    Enum.filter(res, fn lib -> lib.stars >= lower_boundary end)
  end

  defp get_libraries({:from_db, record}, lower_boundary) do
    AwesomeTable.Libraries.list_with_stars_filter(lower_boundary, record.id)
  end

end

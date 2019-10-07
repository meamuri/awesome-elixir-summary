defmodule AwesomeTableWeb.PageController do
  use AwesomeTableWeb, :controller

  def index(conn, parameters) do
    min_stars = calc_lower_boundary(parameters)

    libs = get_libraries(AwesomeTable.Model.latest_request(), min_stars)
    render(conn, "index.html", records: libs)
  end

  defp get_libraries({:new, record}, lower_boundary) do
    res = AwesomeTable.LibrariesAggregator.aggregate
      |> Each.map(AwesomeTable.LibrariesAggregator.add_stars_with_redirect/1)
      |> Each.map(fn lib -> put_in(lib, [:request_id], record.id) end)
    Enum.each(res, fn lib -> AwesomeTable.Libraries.create_library(lib) end)
    res
  end

  defp get_libraries({:from_db, record}, lower_boundary) do
    AwesomeTable.Libraries.list_with_stars_filter(lower_boundary, record.id)
  end

  defp calc_lower_boundary(parameters) do
    min_stars = with min_stars_parameter <- parameters["min_stars"] do
      cond do
        min_stars_parameter != nil -> min_stars_parameter
        true -> "0"
      end
    end
    stars_lower_boundary = Integer.parse(min_stars)
    case stars_lower_boundary do
      {val, _} -> val
      :error -> 0
    end
  end

end

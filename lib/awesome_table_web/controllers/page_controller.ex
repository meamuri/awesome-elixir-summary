defmodule AwesomeTableWeb.PageController do
  use AwesomeTableWeb, :controller

  def index(conn, parameters) do
    libs = AwesomeTable.Libraries.list_libraries
    min_stars = with min_stars_parameter <- parameters["min_stars"] do
      cond do
        min_stars_parameter != nil -> min_stars_parameter
        true -> "0"
      end
    end
    stars_lower_boundary = Integer.parse(min_stars)
    lower_boundary = case stars_lower_boundary do
      {val, _} -> val
      :error -> 0
    end

    render(conn, "index.html", records: Enum.filter(libs, fn r -> r.stars >= lower_boundary end))
  end

#  def index(conn) do
#    index(conn, %{"min_stars" => 0})
#  end
end

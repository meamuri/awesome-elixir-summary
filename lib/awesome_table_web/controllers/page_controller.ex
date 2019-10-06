defmodule AwesomeTableWeb.PageController do
  use AwesomeTableWeb, :controller

  def index(conn, parameters) do
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

    libs = AwesomeTable.Libraries.list_with_stars_filter(lower_boundary)
    render(conn, "index.html", records: libs)
  end

end

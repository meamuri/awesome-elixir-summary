defmodule AwesomeTableWeb.PageController do
  use AwesomeTableWeb, :controller

  def index(conn, %{"min_stars" => min_stars}) do
    libs = AwesomeTable.Libraries.list_libraries
    render(conn, "index.html", records: libs)
  end
end

defmodule AwesomeTableWeb.PageControllerTest do
  use AwesomeTableWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Awesome Table (elixir repositories list)"
  end
end

defmodule AwesomeTableWeb.LiveTable do
  use Phoenix.LiveView
  alias AwesomeTable.Libraries
  require Logger

  def mount(_session, socket) do
    EventBus.subscribe({AwesomeTableWeb.LiveTable, [".*"]})
    {_, latest_request} = AwesomeTable.Requests.latest_request()
    {:ok,
      assign(socket,
        records: Libraries.list_with_stars_filter(0, latest_request.id)
                 |> Enum.sort_by(fn e -> e.title end)
                 |> Enum.group_by(fn e -> e.category end)
                 |> Enum.sort_by(fn {k, _} -> k end)
      )}
  end

  def render(assigns) do
    AwesomeTableWeb.PageView.render("index.html", assigns)
  end

end

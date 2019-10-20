defmodule AwesomeTableWeb.LiveTable do
  use Phoenix.LiveView
  alias AwesomeTable.Libraries
  require Logger

  def mount(_session, socket) do
    if connected?(socket), do: AwesomeTable.StarsCheckingWorker.register(self())
    {:ok,
      assign(socket,
        records: compute_records()
      )}
  end

  def render(assigns) do
    AwesomeTableWeb.PageView.render("index.html", assigns)
  end

  def handle_info(:update, socket) do
    {:noreply, assign(socket, records: compute_records())}
  end

  def compute_records() do
    {_, latest_request} = AwesomeTable.Requests.latest_request()
    Libraries.list_with_stars_filter(0, latest_request.id)
    |> Enum.sort_by(fn e -> e.title end)
    |> Enum.group_by(fn e -> e.category end)
    |> Enum.sort_by(fn {k, _} -> k end)
  end

end

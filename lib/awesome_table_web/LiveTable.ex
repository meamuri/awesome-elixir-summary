defmodule AwesomeTableWeb.LiveTable do
  use Phoenix.LiveView
  alias AwesomeTable.Libraries
  require Logger

  def mount(_session, socket) do
    EventBus.subscribe({AwesomeTableWeb.LiveTable, [".*"]})
    {:ok,
      assign(socket,
        records: Libraries.list_with_stars_filter(0, 4)
                 |> Enum.sort_by(fn e -> e.title end)
                 |> Enum.group_by(fn e -> e.category end)
                 |> Enum.sort_by(fn {k, _} -> k end)
      )}
  end

  def render(assigns) do
    AwesomeTableWeb.PageView.render("index.html", assigns)
  end

  def process({topic, id} = event_shadow) do
    GenServer.cast(__MODULE__, event_shadow)
#    send(self(), event_shadow)
    :ok
  end

  def handle_cast({topic, id} = event_shadow, state) do
    Logger.info "MEH"
    IO.puts "EA"
    payment_data = EventBus.fetch_event_data({topic, id})
    # do sth with payment_data
    Logger.info payment_data
    # mark event as completed for this consumer
    EventBus.mark_as_completed({__MODULE__, topic, id})
    {:noreply, state}
  end

  def handle_cast({topic, id} = event_shadow, %{assigns: state} = socket) do
    payment_data = EventBus.fetch_event_data({topic, id})
    # do sth with payment_data
    Logger.info payment_data
    # mark event as completed for this consumer
    EventBus.mark_as_completed({__MODULE__, topic, id})
    {:noreply, assign(socket, state: state)}
  end
end

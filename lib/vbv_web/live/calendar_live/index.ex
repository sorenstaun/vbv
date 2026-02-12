defmodule VbvWeb.CalendarLive.Index do
  use VbvWeb, :live_view
  alias LiveCalendar.Components

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Tasks
        <:actions>
          <.button variant="primary" navigate={~p"/tasks/new"}>
            <.icon name="hero-plus" /> New Task
          </.button>
        </:actions>
      </.header>

      <div>
        <Components.calendar
          id="my-calendar"
          events={@events}
          on_event_click={JS.push("event_selected")}
          options={%{view: "dayGridMonth", headerToolbar: %{start: "prev,next", center: "title", end: "dayGridMonth,listMonth"}}}
        />
      </div>
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    events = [
      %{
        id: 1,
        title: "Sample Event",
        start: "2026-02-12T10:00:00",
        end: "2026-02-15T11:00:00",
        backgroundColor: "#3b82f6"
      },
      %{
        id: 2,
        title: "Sample Event 2",
        start: "2026-02-14T10:00:00",
        end: "2026-02-18T11:00:00",
        backgroundColor: "#10b981"
      }
    ]

    {:ok, assign(socket, events: events)}
  end

  @impl true
  def handle_event("event_clicked", %{"id" => id}, socket) do
    {:noreply, put_flash(socket, :info, "Selected event: #{id}")}
  end

  @impl true
  def handle_event("date_clicked", %{"date" => date}, socket), do: {:noreply, socket}

  @impl true
  def handle_event("month_changed", %{"month" => month, "year" => year}, socket),
    do: {:noreply, socket}
end

defmodule VbvWeb.TaskLive.Index do
  use VbvWeb, :live_view
  import VbvWeb.Components.TaskComponents

  alias Vbv.Tasks

  @impl true
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

      <.table
        id="tasks"
        rows={@streams.tasks}
        row_click={fn {_id, task} -> JS.navigate(~p"/tasks/#{task}") end}
      >
        <:col :let={{_id, task}} label={sort_label("Name", :name, @sort_by, @sort_order)}>
          {task.name}<.icon :if={task.private} name="hero-lock-closed" />
        </:col>
        <:col :let={{_id, task}} label={sort_label("Start date", :start_date, @sort_by, @sort_order)}>
          {task.start_date}
        </:col>
        <:col :let={{_id, task}} label={sort_label("Category", :category, @sort_by, @sort_order)}>
          <.category task={task} />
        </:col>
        <:col :let={{_id, task}} label={sort_label("State", :state, @sort_by, @sort_order)}>
          <.state task={task} />
        </:col>
        <:action :let={{_id, task}}>
          <div class="sr-only">
            <.link navigate={~p"/tasks/#{task}"}>Show</.link>
          </div>
          <.link navigate={~p"/tasks/#{task}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, task}}>
          <.link
            phx-click={JS.push("delete", value: %{id: task.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Tasks.subscribe_tasks(socket.assigns.current_scope)
    end

    sort_by = :name
    sort_order = :asc

    {:ok,
     socket
     |> assign(:page_title, "Listing Tasks")
     |> assign(:sort_by, sort_by)
     |> assign(:sort_order, sort_order)
     |> stream(:tasks, list_tasks(socket.assigns.current_scope, sort_by, sort_order))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(socket.assigns.current_scope, id)
    {:ok, _} = Tasks.delete_task(socket.assigns.current_scope, task)

    {:noreply, stream_delete(socket, :tasks, task)}
  end

  @impl true
  def handle_event("sort", %{"by" => by}, socket) do
    by = String.to_existing_atom(by)

    order =
      if socket.assigns.sort_by == by do
        if socket.assigns.sort_order == :asc, do: :desc, else: :asc
      else
        :asc
      end

    {:noreply,
     socket
     |> assign(:sort_by, by)
     |> assign(:sort_order, order)
     |> stream(:tasks, list_tasks(socket.assigns.current_scope, by, order, true), reset: true)}
  end

  @impl true
  def handle_info({type, %Vbv.Tasks.Task{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply,
     stream(
       socket,
       :tasks,
       list_tasks(
         socket.assigns.current_scope,
         socket.assigns.sort_by,
         socket.assigns.sort_order
       ),
       reset: true
     )}
  end

  def list_tasks(current_scope, sort_by \\ :name, sort_order \\ :asc, _reset \\ false) do
    Tasks.list_tasks(current_scope, sort_by, sort_order)
  end

  # Helper for sortable column labels
  defp sort_label(label, field, sort_by, sort_order) do
    assigns = %{label: label, field: field, sort_by: sort_by, sort_order: sort_order}

    ~H"""
    <span class="cursor-pointer select-none" phx-click={JS.push("sort", value: %{by: @field})}>
      {@label}
      <.icon
        :if={@sort_by == @field and @sort_order == :asc}
        name="hero-arrow-up"
      />
      <.icon
        :if={@sort_by == @field and @sort_order == :desc}
        name="hero-arrow-down"
      />
    </span>
    """
  end
end

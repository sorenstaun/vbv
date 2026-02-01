defmodule VbvWeb.TaskLive.Show do
  use VbvWeb, :live_view
  import VbvWeb.Components.TaskComponents

  alias Vbv.Tasks

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Task: {@task.name}
        <:actions>
          <.button navigate={~p"/tasks"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/tasks/#{@task}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit task
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Description">
          <div class="trix-content prose prose-zinc max-w-none format format-zinc">
            {raw(@task.description)}
          </div>
        </:item>
        <:item title="Start date">{@task.start_date}</:item>
        <:item title="Category"><.category task={@task} /></:item>
        <:item title="State"><.state task={@task} /></:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Tasks.subscribe_tasks(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Task")
     |> assign(:task, Tasks.get_task!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Vbv.Tasks.Task{id: id} = task},
        %{assigns: %{task: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :task, task)}
  end

  def handle_info(
        {:deleted, %Vbv.Tasks.Task{id: id}},
        %{assigns: %{task: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current task was deleted.")
     |> push_navigate(to: ~p"/tasks")}
  end

  def handle_info({type, %Vbv.Tasks.Task{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end

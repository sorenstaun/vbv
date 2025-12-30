defmodule VbvWeb.TaskLive.Form do
  use VbvWeb, :live_view

  alias Vbv.Tasks
  alias Vbv.Tasks.Task

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage task records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="task-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:deadline]} type="date" label="Deadline" />

        <.input type="radiogroup"
          field={@form[:state_id]}
          label="State"
          options={@states}
        />

        <.input type="radiogroup"
          field={@form[:category_id]}
          label="Category"
          options={@categories}
        />

        <.input
          field={@form[:freq]}
          type="select"
          label="Frequency"
          options={[
            {"Daily", "DAILY"},
            {"Weekly", "WEEKLY"},
            {"Monthly", "MONTHLY"},
            {"Yearly", "YEARLY"}
          ]}
        />

        <.input
          field={@form[:interval]}
          type="number"
          label="Interval"
          value="1"
        />
        <input type="number" name="interval" value="1" min="1" />

        <div :if={@form.params["freq"] == "WEEKLY"}>
          Weekly!
        </div>

        <.input
          :if={@form.params["freq"] == "WEEKLY"}
          field={@form[:byday]}
          type="checkgroup"
          label="Select Days of the Week"
          options={[
            {"Monday", "MO"},
            {"Tuesday", "TU"},
            {"Wednesday", "WE"},
            {"Thursday", "TH"},
            {"Friday", "FR"},
            {"Saturday", "SA"},
            {"Sunday", "SU"}
          ]}
        />

        <.input
          :if={@task.user_id == @current_scope.user.id}
          type="checkbox"
          field={@form[:private]}
          label="Private?"
        />

        <div class="mt-4 p-2 bg-gray-100 font-mono">
          Generated Rule: <!--{@changeset.data.rrule}-->
        </div>

        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Task</.button>
          <.button navigate={return_path(@current_scope, @return_to, @task)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    task = Tasks.get_task!(socket.assigns.current_scope, id)

    states = Tasks.state_options()
    categories = Tasks.category_options()

    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, task)
    |> assign(:states, states)
    |> assign(:categories, categories)
    |> assign(:form, to_form(Tasks.change_task(socket.assigns.current_scope, task)))
  end

  defp apply_action(socket, :new, _params) do
    task = %Task{user_id: socket.assigns.current_scope.user.id}

    states = Tasks.state_options()
    categories = Tasks.category_options()

    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, task)
    |> assign(:states, states)
    |> assign(:categories, categories)
    |> assign(:form, to_form(Tasks.change_task(socket.assigns.current_scope, task)))
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset = Tasks.change_task(socket.assigns.current_scope, socket.assigns.task, task_params)
    {:noreply, assign(socket, form: to_form(Map.put(changeset, :action, :validate)))}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, socket.assigns.live_action, task_params)
  end

  defp save_task(socket, :edit, task_params) do
    case Tasks.update_task(socket.assigns.current_scope, socket.assigns.task, task_params) do
      {:ok, task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, task)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_task(socket, :new, task_params) do
    case Tasks.create_task(socket.assigns.current_scope, task_params) do
      {:ok, task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, task)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _task), do: ~p"/tasks"
  defp return_path(_scope, "show", task), do: ~p"/tasks/#{task}"
end

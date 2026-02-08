defmodule VbvWeb.TaskLive.Form do
  use VbvWeb, :live_view

  alias Vbv.Tasks
  alias Vbv.Tasks.Task
  alias VbvWeb.Components.Toggle

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage task records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="task-form" phx-change="validate" phx-submit="save">
        <div class="mb-4 grid grid-cols-3 gap-6">
          <.input field={@form[:name]} type="text" label="Name" />
          <Toggle.render
            :if={@task.user_id == @current_scope.user.id}
            id="private-toggle"
            label="You created this. Is it private?"
            event_name="toggle_private"
            toggled={@form[:private].value}
            field={@form[:private]}
          />
          <Toggle.render
            id="recurring-toggle"
            label="Is this a recurring task?"
            event_name="toggle_recurring"
            toggled={@form[:recurring].value}
            field={@form[:recurring]}
          />
        </div>

    <!-- Recurrence Rule Settings -->

        <div
          :if={@form[:recurring].value == true or @form[:recurring].value == "true"}
          class="grid grid-cols-4 gap-6 bg-gray-300 p-4 rounded"
        >
          <label class="col-span-4 font-bold">Recurrence Rule Settings</label>
          <table class="w-auto border-separate border-spacing-2"><tr>
          <td>
          <.input label="Repeat every" type="number" name="interval" value="1" min="1" class="w-48"/>
          </td><td>
          <.input
            field={@form[:freq]}
            type="select"
            class="w-48"
            label="Frequency"
            options={[
              {"Day", "DAILY"},
              {"Week", "WEEKLY"},
              {"Month", "MONTHLY"},
              {"Year", "YEARLY"}
            ]}
          />
          </td><td class="gap-6">
          <.input
            :if={@form[:freq].value == "WEEKLY"}
            field={@form[:byday]}
            type="weekselector"
            class="w-96"
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
          </td></tr></table>
        </div>

          <div class="mt-4 p-2 bg-gray-100 font-mono">
             <.input field={@form[:rrule]} type="text" label="" readonly />
          </div>

    <!-- Other fields for tasks -->

        <div class="fieldset mb-2">
          <label><span for="trix-input" class="label mb-1">Description</span></label>
          <div phx-update="ignore" id="description-editor-wrapper" class="format format-zinc max-w-none">
            <input
              id="trix-input"
              type="hidden"
              name={@form[:description].name}
              value={@form[:description].value}
            />
            <trix-editor
              id="description-trix-editor"
              input="trix-input"
              phx-hook="TrixEditor"
              class="trix-content border-zinc-300 rounded-lg shadow-sm min-h-[200px]"
            >
            </trix-editor>
          </div>
        </div>

        <!--.input field={@form[:description]} type="textarea" label="Description" /-->
        <div class="mb-4 grid grid-cols-4 gap-6">
          <.input field={@form[:start_date]} type="date" label="Start date" />
          <.input field={@form[:start_time]} type="time" label="Start time" />
          <.input field={@form[:end_date]} type="date" label="End date" />
          <.input field={@form[:end_time]} type="time" label="End time" />

          <.input
            type="select"
            field={@form[:state_id]}
            label="State"
            options={@states}
          />
          <.input
            type="select"
            field={@form[:category_id]}
            label="Category"
            options={@categories}
          />
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
  def handle_event("validate", %{"task" => task}, socket) do
    private_value = socket.assigns.form[:private].value
    recurring_value = socket.assigns.form[:recurring].value

    changeset =
      Tasks.change_task(
        socket.assigns.current_scope,
        socket.assigns.task,
        Map.merge(
          %{
            "private" => private_value,
            "recurring" => recurring_value,
          },
          task
        )
      )

    {:noreply, assign(socket, form: to_form(Map.put(changeset, :action, :validate)))}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, socket.assigns.live_action, task_params)
  end

  def handle_event("toggle_private", %{"id" => _id}, socket) do
    current_value = !socket.assigns.form[:private].value
    recurring_value = socket.assigns.form[:recurring].value

    changeset =
      Tasks.change_task(socket.assigns.current_scope, socket.assigns.task, %{
        "private" => current_value,
        "recurring" => recurring_value
      })

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("toggle_recurring", %{"id" => _id}, socket) do
    current_value = !socket.assigns.form[:recurring].value
    private_value = socket.assigns.form[:private].value

    changeset =
      Tasks.change_task(socket.assigns.current_scope, socket.assigns.task, %{
        "recurring" => current_value,
        "private" => private_value
      })

    {:noreply, assign(socket, form: to_form(changeset))}
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

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

      <div class="mb-6">
        <form phx-change="filter">
          <table>
            <tr>
              <td>
                <.input
                  type="select"
                  field={@filter_form[:state]}
                  label="State"
                  id="filter-state-select"
                  options={[{"All States", ""}] ++ @states}
                  multiple={false}
                  class="flex-1 min-w-[140px] max-w-[200px]"
                  rest={%{name: "filters[state]"}}
                  prompt="Select state"
                />
              </td>
              <td class="pl-4">
                <.input
                  type="select"
                  field={@filter_form[:category]}
                  label="Category"
                  id="filter-category-select"
                  options={[{"All Categories", ""}] ++ @categories}
                  multiple={false}
                  class="flex-1 min-w-[140px] max-w-[200px]"
                  rest={%{name: "filters[category]"}}
                  prompt="Select category"
                />
              </td>
            </tr>
          </table>
        </form>
      </div>

      <.table
        id="tasks"
        rows={@streams.tasks}
        row_click={fn {_id, task} -> JS.navigate(~p"/tasks/#{task}") end}
      >
        <:col :let={{_id, task}} label={sort_label("Name", :name, @sort_by, @sort_order)}>
          <div class="flex items-center gap-2">
            <span class="text-base font-semibold text-slate-700 dark:text-slate-200">
              {task.name}
            </span>

            <.icon
              :if={task.private}
              name="hero-lock-closed-solid"
              class="w-4 h-4 text-slate-400"
            />
          </div>
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
  def mount(params, _session, socket) do
    if connected?(socket) do
      Tasks.subscribe_tasks(socket.assigns.current_scope)
    end

    states = Tasks.state_options()
    categories = Tasks.category_options()

    sort_by = :name
    sort_order = :asc

    defaults = %{"state" => "", "category" => ""}
    filter_params = Map.merge(defaults, params)
    filter_form = Phoenix.Component.to_form(filter_params, as: :filters)

    filters = %{
      scope: socket.assigns.current_scope,
      sort_by: sort_by,
      sort_order: sort_order,
      active_only: true,
      task_filter: %{
        "state" => filter_form.params["state"],
        "category" => filter_form.params["category"]
      }
    }

    {:ok,
     socket
     |> assign(:page_title, "Listing Tasks")
     |> assign(:states, states)
     |> assign(:categories, categories)
     |> assign(:sort_by, sort_by)
     |> assign(:sort_order, sort_order)
     |> assign(:filter_form, filter_form)
     |> stream(:tasks, list_tasks(filters))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    # 1. Update the form struct so the dropdowns show the selected value
    filter_form = Phoenix.Component.to_form(params, as: :filters)

    filters = %{
      scope: socket.assigns.current_scope,
      sort_by: socket.assigns.sort_by,
      sort_order: socket.assigns.sort_order,
      active_only: true,
      task_filter: %{
        "state" => filter_form.params["filters"]["state"],
        "category" => filter_form.params["filters"]["category"]
      }
    }

    # 2. Fetch the data using the params from the URL
    tasks =
      list_tasks(filters)

    {:noreply,
     socket
     |> assign(:filter_form, filter_form)
     # reset: true is key for streams!
     |> stream(:tasks, tasks, reset: true)}
  end

  @impl true
  def handle_event("filter", params, socket) do
    # Just update the URL. Phoenix then calls handle_params automatically.
    {:noreply, push_patch(socket, to: ~p"/tasks?#{params}")}
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

    filter_form = socket.assigns.filter_form

    filters = %{
      scope: socket.assigns.current_scope,
      sort_by: socket.assigns.sort_by,
      sort_order: socket.assigns.sort_order,
      active_only: true,
      task_filter: %{
        "state" => filter_form.params["filters"]["state"],
        "category" => filter_form.params["filters"]["category"]
      }
    }

    {:noreply,
     socket
     |> assign(:sort_by, by)
     |> assign(:sort_order, order)
     |> stream(:tasks, list_tasks(filters), reset: true)}
  end

  @impl true
  def handle_info({type, %Vbv.Tasks.Task{}}, socket)
      when type in [:created, :updated, :deleted] do
    filters = %{
      scope: socket.current_scope,
      sort_by: socket.sort_by,
      sort_order: socket.sort_order,
      active_only: true,
      task_filter: %{
        "state" => get_in(socket.assigns.filter_form, ["filters", "state"]),
        "category" => get_in(socket.assigns.filter_form, ["filters", "category"])
      }
    }

    {:noreply,
     stream(
       socket,
       :tasks,
       list_tasks(filters),
       reset: true
     )}
  end

  def list_tasks(filters) do
    Tasks.list_tasks(filters)
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

defmodule VbvWeb.TaskController do
  use VbvWeb, :controller

  require IEx
  alias Vbv.Tasks
  alias Vbv.Tasks.Task

  def index(conn, _params) do
    tasks = Tasks.list_tasks(conn.assigns.current_scope)
    render(conn, :index, tasks: tasks, task_state_options: Tasks.task_state_options(conn))
  end

  def new(conn, _params) do
    changeset =
      Tasks.change_task(conn.assigns.current_scope, %Task{
        user_id: conn.assigns.current_scope.user.id
      })
    states = Tasks.task_state_options(conn)
    categories = Tasks.category_options(conn)

    render(conn, :new, changeset: changeset, states: states, categories: categories)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(conn.assigns.current_scope, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: ~p"/tasks/#{task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new,
          changeset: changeset,
          task_state_options: Tasks.task_state_options(conn),
          category_options: [] # provide real category options here if available
        )
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(conn.assigns.current_scope, id)
    render(conn, :show, task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Tasks.get_task!(conn.assigns.current_scope, id)
    changeset = Tasks.change_task(conn.assigns.current_scope, task)
    render(conn, :edit, task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(conn.assigns.current_scope, id)

    case Tasks.update_task(conn.assigns.current_scope, task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: ~p"/tasks/#{task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit,
          task: task,
          changeset: changeset,
          task_state_options: Tasks.task_state_options(conn),
          category_options: [] # provide real category options here if available
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(conn.assigns.current_scope, id)
    {:ok, _task} = Tasks.delete_task(conn.assigns.current_scope, task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: ~p"/tasks")
  end
end

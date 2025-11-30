defmodule VbvWeb.TaskStateController do
  use VbvWeb, :controller

  alias Vbv.TaskStates
  alias Vbv.TaskStates.TaskState

  def index(conn, _params) do
    task_states = TaskStates.list_task_states(conn.assigns.current_scope)
    render(conn, :index, task_states: task_states)
  end

  def new(conn, _params) do
    changeset =
      TaskStates.change_task_state(conn.assigns.current_scope, %TaskState{
        user_id: conn.assigns.current_scope.user.id
      })

    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"task_state" => task_state_params}) do
    case TaskStates.create_task_state(conn.assigns.current_scope, task_state_params) do
      {:ok, task_state} ->
        conn
        |> put_flash(:info, "Task state created successfully.")
        |> redirect(to: ~p"/task_states/#{task_state}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task_state = TaskStates.get_task_state!(conn.assigns.current_scope, id)
    render(conn, :show, task_state: task_state)
  end

  def edit(conn, %{"id" => id}) do
    task_state = TaskStates.get_task_state!(conn.assigns.current_scope, id)
    changeset = TaskStates.change_task_state(conn.assigns.current_scope, task_state)
    render(conn, :edit, task_state: task_state, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task_state" => task_state_params}) do
    task_state = TaskStates.get_task_state!(conn.assigns.current_scope, id)

    case TaskStates.update_task_state(conn.assigns.current_scope, task_state, task_state_params) do
      {:ok, task_state} ->
        conn
        |> put_flash(:info, "Task state updated successfully.")
        |> redirect(to: ~p"/task_states/#{task_state}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, task_state: task_state, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task_state = TaskStates.get_task_state!(conn.assigns.current_scope, id)
    {:ok, _task_state} = TaskStates.delete_task_state(conn.assigns.current_scope, task_state)

    conn
    |> put_flash(:info, "Task state deleted successfully.")
    |> redirect(to: ~p"/task_states")
  end
end

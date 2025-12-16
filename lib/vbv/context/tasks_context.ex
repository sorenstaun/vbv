defmodule Vbv.Context.TaskContext do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false

  alias Vbv.Repo
  alias Vbv.Users.Scope
  alias Vbv.Tasks.Task

  def task_preload(tasks) do
    tasks
    |> Repo.preload(:state)
    |> Repo.preload(:category)
  end

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks(scope)
      [%Task{}, ...]

  """
  def list_tasks(%Scope{} = scope) do
    Repo.all_by(Task, user_id: scope.user.id)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(scope, 123)
      %Task{}

      iex> get_task!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(%Scope{} = scope, id) do
    Repo.get_by!(
      # Ensure you add :state to the preload list
      from(t in Task, preload: [:category, :state]),
      id: id,
      user_id: scope.user.id
    )
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(scope, %{field: value})
      {:ok, %Task{}}

      iex> create_task(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(%Scope{} = scope, attrs) do
    with {:ok, task = %Task{}} <-
           %Task{}
           |> Task.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_task(scope, {:created, task})
      {:ok, task}
    end
  end

  defp broadcast_task(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Vbv.PubSub, "user:#{key}:tasks", message)
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(scope, task)
      {:ok, %Task{}}

      iex> delete_task(scope, task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Scope{} = scope, %Task{} = task) do
    true = task.user_id == scope.user.id

    with {:ok, task = %Task{}} <-
           Repo.delete(task) do
      broadcast_task(scope, {:deleted, task})
      {:ok, task}
    end
  end

  def task_state_options(conn) do
    conn.assigns.current_scope
    |> Vbv.TaskStates.list_task_states()
    |> Enum.map(&{&1.name, &1.id})
  end

  def category_options(conn) do
    conn.assigns.current_scope
    |> Vbv.TaskCategories.list_task_categories()
    |> Enum.map(&{&1.name, &1.id})
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(scope, task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(scope, task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Scope{} = scope, %Task{} = task, attrs) do
    true = task.user_id == scope.user.id

    with {:ok, task = %Task{}} <-
           task
           |> Task.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_task(scope, {:updated, task})
      {:ok, task}
    end
  end
end

defmodule Vbv.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false

  require IEx

  alias Vbv.Repo
  alias Vbv.Tasks.Task
  alias Vbv.Users.Scope

  def task_preload(tasks) do
    tasks
    |> Repo.preload(:state)
    |> Repo.preload(:category)
  end

  @doc """
  Subscribes to scoped notifications about any task changes.

  The broadcasted messages match the pattern:

    * {:created, %Task{}}
    * {:updated, %Task{}}
    * {:deleted, %Task{}}

  """
  def subscribe_tasks(%Scope{} = scope) do
    key = scope.user.id
    Phoenix.PubSub.subscribe(Vbv.PubSub, "user:#{key}:tasks")
  end

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks(scope)
      [%Task{}, ...]

  """
  def list_tasks(%Scope{} = scope) do
    Task
    |> where([t], t.user_id == ^scope.user.id or t.private == false)
    |> Repo.all()
    |> task_preload()
  end

  def get_task!(%Scope{} = scope, id) do
    user_id = scope.user.id

    Task
    |> preload([:category, :state])
    |> where([t], t.id == ^id)
    |> where([t], t.user_id == ^user_id or t.private == false)
    |> Repo.one!()
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

  def state_options() do
    Vbv.States.list_states()
    |> Enum.map(&{&1.name, &1.id})
  end

  def category_options() do
    Vbv.Categories.list_categories()
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

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(scope, task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Scope{} = scope, %Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs, scope)
  end
end

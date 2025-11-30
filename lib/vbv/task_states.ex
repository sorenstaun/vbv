defmodule Vbv.TaskStates do
  @moduledoc false

  import Ecto.Query, warn: false
  alias Vbv.Repo
  alias Vbv.TaskStates.TaskState

  @doc """
  Subscribes to scoped notifications about any task_state changes.

  The broadcasted messages match the pattern:

    * {:created, %TaskState{}}
    * {:updated, %TaskState{}}
    * {:deleted, %TaskState{}}

  """
  def subscribe_task_states(scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Vbv.PubSub, "user:#{key}:task_states")
  end

  defp broadcast_task_state(scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Vbv.PubSub, "user:#{key}:task_states", message)
  end

  @doc """
  Returns the list of task_states.

  ## Examples

      iex> list_task_states(scope)
      [%TaskState{}, ...]

  """
  def list_task_states(scope) do
    Repo.all_by(TaskState, user_id: scope.user.id)
  end

  @doc """
  Gets a single task_state.

  Raises `Ecto.NoResultsError` if the Task state does not exist.

  ## Examples

      iex> get_task_state!(scope, 123)
      %TaskState{}

      iex> get_task_state!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_task_state!(scope, id) do
    Repo.get_by!(TaskState, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a task_state.

  ## Examples

      iex> create_task_state(scope, %{field: value})
      {:ok, %TaskState{}}

      iex> create_task_state(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task_state(scope, attrs) do
    with {:ok, task_state = %TaskState{}} <-
           %TaskState{}
           |> TaskState.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_task_state(scope, {:created, task_state})
      {:ok, task_state}
    end
  end

  @doc """
  Updates a task_state.

  ## Examples

      iex> update_task_state(scope, task_state, %{field: new_value})
      {:ok, %TaskState{}}

      iex> update_task_state(scope, task_state, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task_state(scope, %TaskState{} = task_state, attrs) do
    true = task_state.user_id == scope.user.id

    with {:ok, task_state = %TaskState{}} <-
           task_state
           |> TaskState.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_task_state(scope, {:updated, task_state})
      {:ok, task_state}
    end
  end

  @doc """
  Deletes a task_state.

  ## Examples

      iex> delete_task_state(scope, task_state)
      {:ok, %TaskState{}}

      iex> delete_task_state(scope, task_state)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task_state(scope, %TaskState{} = task_state) do
    true = task_state.user_id == scope.user.id

    with {:ok, task_state = %TaskState{}} <-
           Repo.delete(task_state) do
      broadcast_task_state(scope, {:deleted, task_state})
      {:ok, task_state}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task_state changes.

  ## Examples

      iex> change_task_state(scope, task_state)
      %Ecto.Changeset{data: %TaskState{}}

  """
  def change_task_state(scope, %TaskState{} = task_state, attrs \\ %{}) do
    # For new task_states the user_id is nil — only enforce ownership check
    # when the task_state already has a user_id.
    if task_state.user_id != nil do
      true = task_state.user_id == scope.user.id
    end

    TaskState.changeset(task_state, attrs, scope)
  end
end

defmodule Vbv.TaskCategories do
  @moduledoc """
  The TaskCategories context.
  """

  import Ecto.Query, warn: false
  alias Vbv.Repo

  alias Vbv.TaskCategories.TaskCategory
  alias Vbv.Users.Scope

  @doc """
  Subscribes to scoped notifications about any task_category changes.

  The broadcasted messages match the pattern:

    * {:created, %TaskCategory{}}
    * {:updated, %TaskCategory{}}
    * {:deleted, %TaskCategory{}}

  """
  def subscribe_task_categories(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Vbv.PubSub, "user:#{key}:task_categories")
  end

  defp broadcast_task_category(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Vbv.PubSub, "user:#{key}:task_categories", message)
  end

  @doc """
  Returns the list of task_categories.

  ## Examples

      iex> list_task_categories(scope)
      [%TaskCategory{}, ...]

  """
  def list_task_categories(%Scope{} = scope) do
    Repo.all_by(TaskCategory, user_id: scope.user.id)
  end

  @doc """
  Gets a single task_category.

  Raises `Ecto.NoResultsError` if the Task category does not exist.

  ## Examples

      iex> get_task_category!(scope, 123)
      %TaskCategory{}

      iex> get_task_category!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_task_category!(%Scope{} = scope, id) do
    Repo.get_by!(TaskCategory, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a task_category.

  ## Examples

      iex> create_task_category(scope, %{field: value})
      {:ok, %TaskCategory{}}

      iex> create_task_category(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task_category(%Scope{} = scope, attrs) do
    with {:ok, task_category = %TaskCategory{}} <-
           %TaskCategory{}
           |> TaskCategory.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_task_category(scope, {:created, task_category})
      {:ok, task_category}
    end
  end

  @doc """
  Updates a task_category.

  ## Examples

      iex> update_task_category(scope, task_category, %{field: new_value})
      {:ok, %TaskCategory{}}

      iex> update_task_category(scope, task_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task_category(%Scope{} = scope, %TaskCategory{} = task_category, attrs) do
    true = task_category.user_id == scope.user.id

    with {:ok, task_category = %TaskCategory{}} <-
           task_category
           |> TaskCategory.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_task_category(scope, {:updated, task_category})
      {:ok, task_category}
    end
  end

  @doc """
  Deletes a task_category.

  ## Examples

      iex> delete_task_category(scope, task_category)
      {:ok, %TaskCategory{}}

      iex> delete_task_category(scope, task_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task_category(%Scope{} = scope, %TaskCategory{} = task_category) do
    true = task_category.user_id == scope.user.id

    with {:ok, task_category = %TaskCategory{}} <-
           Repo.delete(task_category) do
      broadcast_task_category(scope, {:deleted, task_category})
      {:ok, task_category}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task_category changes.

  ## Examples

      iex> change_task_category(scope, task_category)
      %Ecto.Changeset{data: %TaskCategory{}}

  """
  def change_task_category(%Scope{} = scope, %TaskCategory{} = task_category, attrs \\ %{}) do
    true = task_category.user_id == scope.user.id

    TaskCategory.changeset(task_category, attrs, scope)
  end
end

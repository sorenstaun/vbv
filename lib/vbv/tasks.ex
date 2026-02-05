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
  def list_tasks(filters \\ %{}) do
    sort_by = Map.get(filters, :sort_by, :name)
    sort_order = Map.get(filters, :sort_order, :asc)
    scope = Map.get(filters, :scope)
    filters = Map.get(filters, :task_filter, %{})

    sort_field =
      case sort_by do
        :name -> :name
        :start_date -> :start_date
        :category -> :category_id
        :state -> :state_id
        _ -> :name
      end

    order_by_expr =
      case sort_order do
        :asc -> [asc: sort_field]
        :desc -> [desc: sort_field]
        _ -> [asc: sort_field]
      end

    IO.inspect(filters, label: "Task list filters")

    Task
    |> where([t], t.user_id == ^scope.user.id or t.private == false)
    |> order_by(^order_by_expr)
    |> filter_by_state(Map.get(filters, "state"))
    |> filter_by_category(Map.get(filters, "category"))
    |> Repo.all()
    |> task_preload()
  end

  # If the param is empty/missing, return the query as-is
  defp filter_by_state(query, state) when state in ["", nil], do: query
  # If it's a number (ID), filter by it
  defp filter_by_state(query, state), do: where(query, state_id: ^state)

  defp filter_by_category(query, cat) when cat in ["", nil], do: query
  defp filter_by_category(query, cat), do: where(query, category_id: ^cat)

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

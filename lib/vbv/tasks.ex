defmodule Vbv.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false

  require IEx

  alias Vbv.Tasks.Task
  alias Vbv.Users.Scope

  alias Vbv.Context.TaskContext

  def list_tasks(%Scope{} = scope) do

    TaskContext.list_tasks(scope)
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


  def get_task!(%Scope{} = scope, id) do
    TaskContext.get_task!(scope, id)
  end


  def create_task(%Scope{} = scope, attrs) do
    TaskContext.create_task(scope, attrs)
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
    TaskContext.update_task(scope, task, attrs)
  end

  def delete_task(%Scope{} = scope, %Task{} = task) do
    TaskContext.delete_task(scope, task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(scope, task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Scope{} = scope, %Task{} = task, attrs \\ %{}) do
    true = task.user_id == scope.user.id

    Task.changeset(task, attrs, scope)
  end
end

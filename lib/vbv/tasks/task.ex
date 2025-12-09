defmodule Vbv.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :deadline, :date
    field :user_id, :id

    belongs_to :category, Vbv.TaskCategories.TaskCategory
    belongs_to :state, Vbv.TaskStates.TaskState

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs, user_scope) do
    task
    |> cast(attrs, [:name, :description, :deadline])
    |> validate_required([:name, :description, :deadline])
    |> put_change(:user_id, user_scope.user.id)
  end
end

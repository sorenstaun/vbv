defmodule Vbv.TaskStates.TaskState do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task_states" do
    field :name, :string
    field :colour, :string
    field :icon, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task_state, attrs, user_scope) do
    task_state
    |> cast(attrs, [:name, :colour, :icon])
    |> validate_required([:name, :colour, :icon])
    |> put_change(:user_id, user_scope.user.id)
  end
end

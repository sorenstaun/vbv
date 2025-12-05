defmodule Vbv.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :deadline, :date
    field :category, :id
    field :state, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs, user_scope) do
    task
    |> cast(attrs, [:name, :description, :deadline, :category, :state])
    |> validate_required([:name, :description, :deadline])
    |> put_change(:user_id, user_scope.user.id)
  end
end

defmodule Vbv.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :deadline, :date
    field :user_id, :id
    field :rrule, :string

    # Virtual fields for tasks

    field :freq, :string, virtual: true
    field :interval, :integer, virtual: true

    # Associations

    belongs_to :category, Vbv.Categories.Category
    belongs_to :state, Vbv.States.State

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs, user_scope) do
    task
    |> cast(attrs, [:name, :description, :deadline, :state_id, :category_id, :rrule])
    |> validate_required([:name, :description, :deadline])
    |> put_change(:user_id, user_scope.user.id)
  end
end

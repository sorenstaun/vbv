defmodule Vbv.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :start_date, :date
    field :end_date, :date
    field :start_time, :time
    field :end_time, :time
    field :recurring, :boolean, default: false
    field :user_id, :id
    field :rrule, :string
    field :private, :boolean, default: false

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
    |> cast(attrs, [:name, :description, :start_date, :start_time, :end_date, :end_time, :state_id, :category_id, :rrule, :private, :recurring])
    |> validate_required([:name, :description, :start_date])
    |> put_change(:user_id, user_scope.user.id)
  end
end

defmodule Vbv.TaskCategories.TaskCategory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task_categories" do
    field :name, :string
    field :colour, :string
    field :icon, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task_category, attrs, user_scope) do
    task_category
    |> cast(attrs, [:name, :colour, :icon])
    |> validate_required([:name, :colour, :icon])
    |> put_change(:user_id, user_scope.user.id)
  end
end

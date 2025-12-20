defmodule Vbv.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string
    field :colour, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs, user_scope) do
    category
    |> cast(attrs, [:name, :colour])
    |> validate_required([:name, :colour])
    |> put_change(:user_id, user_scope.user.id)
  end
end

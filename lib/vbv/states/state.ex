defmodule Vbv.States.State do
  use Ecto.Schema
  import Ecto.Changeset

  schema "states" do
    field :name, :string
    field :colour, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(state, attrs, user_scope) do
    state
    |> cast(attrs, [:name, :colour])
    |> validate_required([:name, :colour])
    |> put_change(:user_id, user_scope.user.id)
  end
end

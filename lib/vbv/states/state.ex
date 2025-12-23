defmodule Vbv.States.State do
  use Ecto.Schema
  import Ecto.Changeset

  schema "states" do
    field :name, :string
    field :colour, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(state, attrs) do
    state
    |> cast(attrs, [:name, :colour])
    |> validate_required([:name, :colour])
  end
end

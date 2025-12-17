defmodule Vbv.StatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vbv.States` context.
  """

  @doc """
  Generate a state.
  """
  def state_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        colour: "some colour",
        icon: "some icon",
        name: "some name"
      })

    {:ok, state} = Vbv.States.create_state(scope, attrs)
    state
  end
end

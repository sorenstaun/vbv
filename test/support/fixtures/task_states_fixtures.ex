defmodule Vbv.TaskStatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vbv.TaskStates` context.
  """

  @doc """
  Generate a task_state.
  """
  def task_state_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        colour: "some colour",
        icon: "some icon",
        name: "some name"
      })

    {:ok, task_state} = Vbv.TaskStates.create_task_state(scope, attrs)
    task_state
  end
end

defmodule Vbv.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vbv.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        deadline: ~D[2025-11-29],
        description: "some description",
        name: "some name"
      })

    {:ok, task} = Vbv.Tasks.create_task(scope, attrs)
    task
  end
end

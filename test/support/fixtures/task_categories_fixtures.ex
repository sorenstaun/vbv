defmodule Vbv.TaskCategoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vbv.TaskCategories` context.
  """

  @doc """
  Generate a task_category.
  """
  def task_category_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        colour: "some colour",
        icon: "some icon",
        name: "some name"
      })

    {:ok, task_category} = Vbv.TaskCategories.create_task_category(scope, attrs)
    task_category
  end
end

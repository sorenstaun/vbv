defmodule Vbv.CategoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vbv.Categories` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        colour: "some colour",
        icon: "some icon",
        name: "some name"
      })

    {:ok, category} = Vbv.Categories.create_category(scope, attrs)
    category
  end
end

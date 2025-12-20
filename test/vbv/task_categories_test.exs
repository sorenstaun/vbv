defmodule Vbv.CategoriesTest do
  use Vbv.DataCase

  alias Vbv.Categories

  describe "categories" do
    alias Vbv.Categories.Category

    import Vbv.UsersFixtures, only: [user_scope_fixture: 0]
    import Vbv.CategoriesFixtures

    @invalid_attrs %{name: nil, colour: nil, icon: nil}

    test "list_categories/1 returns all scoped categories" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      category = category_fixture(scope)
      other_category = category_fixture(other_scope)
      assert Categories.list_categories(scope) == [category]
      assert Categories.list_categories(other_scope) == [other_category]
    end

    test "get_category!/2 returns the category with given id" do
      scope = user_scope_fixture()
      category = category_fixture(scope)
      other_scope = user_scope_fixture()
      assert Categories.get_category!(scope, category.id) == category

      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_category!(other_scope, category.id)
      end
    end

    test "create_category/2 with valid data creates a category" do
      valid_attrs = %{name: "some name", colour: "some colour", icon: "some icon"}
      scope = user_scope_fixture()

      assert {:ok, %Category{} = category} =
               Categories.create_category(scope, valid_attrs)

      assert category.name == "some name"
      assert category.colour == "some colour"
      assert category.icon == "some icon"
      assert category.user_id == scope.user.id
    end

    test "create_category/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Categories.create_category(scope, @invalid_attrs)
    end

    test "update_category/3 with valid data updates the category" do
      scope = user_scope_fixture()
      category = category_fixture(scope)

      update_attrs = %{
        name: "some updated name",
        colour: "some updated colour",
        icon: "some updated icon"
      }

      assert {:ok, %Category{} = category} =
               Categories.update_category(scope, category, update_attrs)

      assert category.name == "some updated name"
      assert category.colour == "some updated colour"
      assert category.icon == "some updated icon"
    end

    test "update_category/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      category = category_fixture(scope)

      assert_raise MatchError, fn ->
        Categories.update_category(other_scope, category, %{})
      end
    end

    test "update_category/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      category = category_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Categories.update_category(scope, category, @invalid_attrs)

      assert category == Categories.get_category!(scope, category.id)
    end

    test "delete_category/2 deletes the category" do
      scope = user_scope_fixture()
      category = category_fixture(scope)
      assert {:ok, %Category{}} = Categories.delete_category(scope, category)

      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_category!(scope, category.id)
      end
    end

    test "delete_category/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      category = category_fixture(scope)

      assert_raise MatchError, fn ->
        Categories.delete_category(other_scope, category)
      end
    end

    test "change_category/2 returns a category changeset" do
      scope = user_scope_fixture()
      category = category_fixture(scope)
      assert %Ecto.Changeset{} = Categories.change_category(scope, category)
    end
  end
end

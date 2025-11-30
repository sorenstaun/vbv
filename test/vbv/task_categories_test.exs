defmodule Vbv.TaskCategoriesTest do
  use Vbv.DataCase

  alias Vbv.TaskCategories

  describe "task_categories" do
    alias Vbv.TaskCategories.TaskCategory

    import Vbv.UsersFixtures, only: [user_scope_fixture: 0]
    import Vbv.TaskCategoriesFixtures

    @invalid_attrs %{name: nil, colour: nil, icon: nil}

    test "list_task_categories/1 returns all scoped task_categories" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      task_category = task_category_fixture(scope)
      other_task_category = task_category_fixture(other_scope)
      assert TaskCategories.list_task_categories(scope) == [task_category]
      assert TaskCategories.list_task_categories(other_scope) == [other_task_category]
    end

    test "get_task_category!/2 returns the task_category with given id" do
      scope = user_scope_fixture()
      task_category = task_category_fixture(scope)
      other_scope = user_scope_fixture()
      assert TaskCategories.get_task_category!(scope, task_category.id) == task_category

      assert_raise Ecto.NoResultsError, fn ->
        TaskCategories.get_task_category!(other_scope, task_category.id)
      end
    end

    test "create_task_category/2 with valid data creates a task_category" do
      valid_attrs = %{name: "some name", colour: "some colour", icon: "some icon"}
      scope = user_scope_fixture()

      assert {:ok, %TaskCategory{} = task_category} =
               TaskCategories.create_task_category(scope, valid_attrs)

      assert task_category.name == "some name"
      assert task_category.colour == "some colour"
      assert task_category.icon == "some icon"
      assert task_category.user_id == scope.user.id
    end

    test "create_task_category/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()

      assert {:error, %Ecto.Changeset{}} =
               TaskCategories.create_task_category(scope, @invalid_attrs)
    end

    test "update_task_category/3 with valid data updates the task_category" do
      scope = user_scope_fixture()
      task_category = task_category_fixture(scope)

      update_attrs = %{
        name: "some updated name",
        colour: "some updated colour",
        icon: "some updated icon"
      }

      assert {:ok, %TaskCategory{} = task_category} =
               TaskCategories.update_task_category(scope, task_category, update_attrs)

      assert task_category.name == "some updated name"
      assert task_category.colour == "some updated colour"
      assert task_category.icon == "some updated icon"
    end

    test "update_task_category/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      task_category = task_category_fixture(scope)

      assert_raise MatchError, fn ->
        TaskCategories.update_task_category(other_scope, task_category, %{})
      end
    end

    test "update_task_category/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      task_category = task_category_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               TaskCategories.update_task_category(scope, task_category, @invalid_attrs)

      assert task_category == TaskCategories.get_task_category!(scope, task_category.id)
    end

    test "delete_task_category/2 deletes the task_category" do
      scope = user_scope_fixture()
      task_category = task_category_fixture(scope)
      assert {:ok, %TaskCategory{}} = TaskCategories.delete_task_category(scope, task_category)

      assert_raise Ecto.NoResultsError, fn ->
        TaskCategories.get_task_category!(scope, task_category.id)
      end
    end

    test "delete_task_category/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      task_category = task_category_fixture(scope)

      assert_raise MatchError, fn ->
        TaskCategories.delete_task_category(other_scope, task_category)
      end
    end

    test "change_task_category/2 returns a task_category changeset" do
      scope = user_scope_fixture()
      task_category = task_category_fixture(scope)
      assert %Ecto.Changeset{} = TaskCategories.change_task_category(scope, task_category)
    end
  end
end

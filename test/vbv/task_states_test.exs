defmodule Vbv.TaskStatesTest do
  use Vbv.DataCase

  alias Vbv.TaskStates

  describe "task_states" do
    alias Vbv.TaskStates.TaskState

    import Vbv.UsersFixtures, only: [user_scope_fixture: 0]
    import Vbv.TaskStatesFixtures

    @invalid_attrs %{name: nil, colour: nil, icon: nil}

    test "list_task_states/1 returns all scoped task_states" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      task_state = task_state_fixture(scope)
      other_task_state = task_state_fixture(other_scope)
      assert TaskStates.list_task_states(scope) == [task_state]
      assert TaskStates.list_task_states(other_scope) == [other_task_state]
    end

    test "get_task_state!/2 returns the task_state with given id" do
      scope = user_scope_fixture()
      task_state = task_state_fixture(scope)
      other_scope = user_scope_fixture()
      assert TaskStates.get_task_state!(scope, task_state.id) == task_state

      assert_raise Ecto.NoResultsError, fn ->
        TaskStates.get_task_state!(other_scope, task_state.id)
      end
    end

    test "create_task_state/2 with valid data creates a task_state" do
      valid_attrs = %{name: "some name", colour: "some colour", icon: "some icon"}
      scope = user_scope_fixture()

      assert {:ok, %TaskState{} = task_state} = TaskStates.create_task_state(scope, valid_attrs)
      assert task_state.name == "some name"
      assert task_state.colour == "some colour"
      assert task_state.icon == "some icon"
      assert task_state.user_id == scope.user.id
    end

    test "create_task_state/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskStates.create_task_state(scope, @invalid_attrs)
    end

    test "update_task_state/3 with valid data updates the task_state" do
      scope = user_scope_fixture()
      task_state = task_state_fixture(scope)

      update_attrs = %{
        name: "some updated name",
        colour: "some updated colour",
        icon: "some updated icon"
      }

      assert {:ok, %TaskState{} = task_state} =
               TaskStates.update_task_state(scope, task_state, update_attrs)

      assert task_state.name == "some updated name"
      assert task_state.colour == "some updated colour"
      assert task_state.icon == "some updated icon"
    end

    test "update_task_state/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      task_state = task_state_fixture(scope)

      assert_raise MatchError, fn ->
        TaskStates.update_task_state(other_scope, task_state, %{})
      end
    end

    test "update_task_state/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      task_state = task_state_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               TaskStates.update_task_state(scope, task_state, @invalid_attrs)

      assert task_state == TaskStates.get_task_state!(scope, task_state.id)
    end

    test "delete_task_state/2 deletes the task_state" do
      scope = user_scope_fixture()
      task_state = task_state_fixture(scope)
      assert {:ok, %TaskState{}} = TaskStates.delete_task_state(scope, task_state)
      assert_raise Ecto.NoResultsError, fn -> TaskStates.get_task_state!(scope, task_state.id) end
    end

    test "delete_task_state/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      task_state = task_state_fixture(scope)
      assert_raise MatchError, fn -> TaskStates.delete_task_state(other_scope, task_state) end
    end

    test "change_task_state/2 returns a task_state changeset" do
      scope = user_scope_fixture()
      task_state = task_state_fixture(scope)
      assert %Ecto.Changeset{} = TaskStates.change_task_state(scope, task_state)
    end
  end
end

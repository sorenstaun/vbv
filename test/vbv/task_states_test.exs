defmodule Vbv.StatesTest do
  use Vbv.DataCase

  alias Vbv.States

  describe "states" do
    alias Vbv.States.State

    import Vbv.UsersFixtures, only: [user_scope_fixture: 0]
    import Vbv.StatesFixtures

    @invalid_attrs %{name: nil, colour: nil, icon: nil}

    test "list_states/1 returns all scoped states" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      state = state_fixture(scope)
      other_state = state_fixture(other_scope)
      assert States.list_states(scope) == [state]
      assert States.list_states(other_scope) == [other_state]
    end

    test "get_state!/2 returns the state with given id" do
      scope = user_scope_fixture()
      state = state_fixture(scope)
      other_scope = user_scope_fixture()
      assert States.get_state!(scope, state.id) == state

      assert_raise Ecto.NoResultsError, fn ->
        States.get_state!(other_scope, state.id)
      end
    end

    test "create_state/2 with valid data creates a state" do
      valid_attrs = %{name: "some name", colour: "some colour", icon: "some icon"}
      scope = user_scope_fixture()

      assert {:ok, %State{} = state} = States.create_state(scope, valid_attrs)
      assert state.name == "some name"
      assert state.colour == "some colour"
      assert state.icon == "some icon"
      assert state.user_id == scope.user.id
    end

    test "create_state/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = States.create_state(scope, @invalid_attrs)
    end

    test "update_state/3 with valid data updates the state" do
      scope = user_scope_fixture()
      state = state_fixture(scope)

      update_attrs = %{
        name: "some updated name",
        colour: "some updated colour",
        icon: "some updated icon"
      }

      assert {:ok, %State{} = state} =
               States.update_state(scope, state, update_attrs)

      assert state.name == "some updated name"
      assert state.colour == "some updated colour"
      assert state.icon == "some updated icon"
    end

    test "update_state/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      state = state_fixture(scope)

      assert_raise MatchError, fn ->
        States.update_state(other_scope, state, %{})
      end
    end

    test "update_state/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      state = state_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               States.update_state(scope, state, @invalid_attrs)

      assert state == States.get_state!(scope, state.id)
    end

    test "delete_state/2 deletes the state" do
      scope = user_scope_fixture()
      state = state_fixture(scope)
      assert {:ok, %State{}} = States.delete_state(scope, state)
      assert_raise Ecto.NoResultsError, fn -> States.get_state!(scope, state.id) end
    end

    test "delete_state/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      state = state_fixture(scope)
      assert_raise MatchError, fn -> States.delete_state(other_scope, state) end
    end

    test "change_state/2 returns a state changeset" do
      scope = user_scope_fixture()
      state = state_fixture(scope)
      assert %Ecto.Changeset{} = States.change_state(scope, state)
    end
  end
end

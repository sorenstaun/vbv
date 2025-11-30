defmodule VbvWeb.TaskStateControllerTest do
  use VbvWeb.ConnCase

  import Vbv.TaskStatesFixtures

  @create_attrs %{name: "some name", colour: "some colour", icon: "some icon"}
  @update_attrs %{
    name: "some updated name",
    colour: "some updated colour",
    icon: "some updated icon"
  }
  @invalid_attrs %{name: nil, colour: nil, icon: nil}

  setup :register_and_log_in_user

  describe "index" do
    test "lists all task_states", %{conn: conn} do
      conn = get(conn, ~p"/task_states")
      assert html_response(conn, 200) =~ "Listing Task states"
    end
  end

  describe "new task_state" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/task_states/new")
      assert html_response(conn, 200) =~ "New Task state"
    end
  end

  describe "create task_state" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/task_states", task_state: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/task_states/#{id}"

      conn = get(conn, ~p"/task_states/#{id}")
      assert html_response(conn, 200) =~ "Task state #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/task_states", task_state: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Task state"
    end
  end

  describe "edit task_state" do
    setup [:create_task_state]

    test "renders form for editing chosen task_state", %{conn: conn, task_state: task_state} do
      conn = get(conn, ~p"/task_states/#{task_state}/edit")
      assert html_response(conn, 200) =~ "Edit Task state"
    end
  end

  describe "update task_state" do
    setup [:create_task_state]

    test "redirects when data is valid", %{conn: conn, task_state: task_state} do
      conn = put(conn, ~p"/task_states/#{task_state}", task_state: @update_attrs)
      assert redirected_to(conn) == ~p"/task_states/#{task_state}"

      conn = get(conn, ~p"/task_states/#{task_state}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, task_state: task_state} do
      conn = put(conn, ~p"/task_states/#{task_state}", task_state: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Task state"
    end
  end

  describe "delete task_state" do
    setup [:create_task_state]

    test "deletes chosen task_state", %{conn: conn, task_state: task_state} do
      conn = delete(conn, ~p"/task_states/#{task_state}")
      assert redirected_to(conn) == ~p"/task_states"

      assert_error_sent 404, fn ->
        get(conn, ~p"/task_states/#{task_state}")
      end
    end
  end

  defp create_task_state(%{scope: scope}) do
    task_state = task_state_fixture(scope)

    %{task_state: task_state}
  end
end

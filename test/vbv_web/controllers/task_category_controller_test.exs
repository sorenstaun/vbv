defmodule VbvWeb.TaskCategoryControllerTest do
  use VbvWeb.ConnCase

  import Vbv.TaskCategoriesFixtures

  @create_attrs %{name: "some name", colour: "some colour", icon: "some icon"}
  @update_attrs %{
    name: "some updated name",
    colour: "some updated colour",
    icon: "some updated icon"
  }
  @invalid_attrs %{name: nil, colour: nil, icon: nil}

  setup :register_and_log_in_user

  describe "index" do
    test "lists all task_categories", %{conn: conn} do
      conn = get(conn, ~p"/task_categories")
      assert html_response(conn, 200) =~ "Listing Task categories"
    end
  end

  describe "new task_category" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/task_categories/new")
      assert html_response(conn, 200) =~ "New Task category"
    end
  end

  describe "create task_category" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/task_categories", task_category: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/task_categories/#{id}"

      conn = get(conn, ~p"/task_categories/#{id}")
      assert html_response(conn, 200) =~ "Task category #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/task_categories", task_category: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Task category"
    end
  end

  describe "edit task_category" do
    setup [:create_task_category]

    test "renders form for editing chosen task_category", %{
      conn: conn,
      task_category: task_category
    } do
      conn = get(conn, ~p"/task_categories/#{task_category}/edit")
      assert html_response(conn, 200) =~ "Edit Task category"
    end
  end

  describe "update task_category" do
    setup [:create_task_category]

    test "redirects when data is valid", %{conn: conn, task_category: task_category} do
      conn = put(conn, ~p"/task_categories/#{task_category}", task_category: @update_attrs)
      assert redirected_to(conn) == ~p"/task_categories/#{task_category}"

      conn = get(conn, ~p"/task_categories/#{task_category}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, task_category: task_category} do
      conn = put(conn, ~p"/task_categories/#{task_category}", task_category: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Task category"
    end
  end

  describe "delete task_category" do
    setup [:create_task_category]

    test "deletes chosen task_category", %{conn: conn, task_category: task_category} do
      conn = delete(conn, ~p"/task_categories/#{task_category}")
      assert redirected_to(conn) == ~p"/task_categories"

      assert_error_sent 404, fn ->
        get(conn, ~p"/task_categories/#{task_category}")
      end
    end
  end

  defp create_task_category(%{scope: scope}) do
    task_category = task_category_fixture(scope)

    %{task_category: task_category}
  end
end

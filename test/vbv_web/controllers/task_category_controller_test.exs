defmodule VbvWeb.CategoryControllerTest do
  use VbvWeb.ConnCase

  import Vbv.CategoriesFixtures

  @create_attrs %{name: "some name", colour: "some colour", icon: "some icon"}
  @update_attrs %{
    name: "some updated name",
    colour: "some updated colour",
    icon: "some updated icon"
  }
  @invalid_attrs %{name: nil, colour: nil, icon: nil}

  setup :register_and_log_in_user

  describe "index" do
    test "lists all categories", %{conn: conn} do
      conn = get(conn, ~p"/categories")
      assert html_response(conn, 200) =~ "Listing Categories"
    end
  end

  describe "new category" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/categories/new")
      assert html_response(conn, 200) =~ "New Task category"
    end
  end

  describe "create category" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/categories", category: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/categories/#{id}"

      conn = get(conn, ~p"/categories/#{id}")
      assert html_response(conn, 200) =~ "Task category #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/categories", category: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Task category"
    end
  end

  describe "edit category" do
    setup [:create_category]

    test "renders form for editing chosen category", %{
      conn: conn,
      category: category
    } do
      conn = get(conn, ~p"/categories/#{category}/edit")
      assert html_response(conn, 200) =~ "Edit Task category"
    end
  end

  describe "update category" do
    setup [:create_category]

    test "redirects when data is valid", %{conn: conn, category: category} do
      conn = put(conn, ~p"/categories/#{category}", category: @update_attrs)
      assert redirected_to(conn) == ~p"/categories/#{category}"

      conn = get(conn, ~p"/categories/#{category}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, category: category} do
      conn = put(conn, ~p"/categories/#{category}", category: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Task category"
    end
  end

  describe "delete category" do
    setup [:create_category]

    test "deletes chosen category", %{conn: conn, category: category} do
      conn = delete(conn, ~p"/categories/#{category}")
      assert redirected_to(conn) == ~p"/categories"

      assert_error_sent 404, fn ->
        get(conn, ~p"/categories/#{category}")
      end
    end
  end

  defp create_category(%{scope: scope}) do
    category = category_fixture(scope)

    %{category: category}
  end
end

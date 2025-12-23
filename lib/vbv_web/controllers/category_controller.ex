defmodule VbvWeb.CategoryController do
  use VbvWeb, :controller

  alias Vbv.Categories
  alias Vbv.Categories.Category

  def index(conn, _params) do
    categories = Categories.list_categories()
    render(conn, :index, categories: categories)
  end

  def new(conn, _params) do
    changeset =
      Categories.change_category(conn.assigns.current_scope, %Category{})

    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case Categories.create_category(conn.assigns.current_scope, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Task category created successfully.")
        |> redirect(to: ~p"/categories/#{category}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Categories.get_category!(conn.assigns.current_scope, id)
    render(conn, :show, category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = Categories.get_category!(conn.assigns.current_scope, id)
    changeset = Categories.change_category(category)
    render(conn, :edit, category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Categories.get_category!(conn.assigns.current_scope, id)

    case Categories.update_category(
           conn.assigns.current_scope,
           category,
           category_params
         ) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Task category updated successfully.")
        |> redirect(to: ~p"/categories/#{category}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Categories.get_category!(conn.assigns.current_scope, id)

    {:ok, _category} =
      Categories.delete_category(conn.assigns.current_scope, category)

    conn
    |> put_flash(:info, "Task category deleted successfully.")
    |> redirect(to: ~p"/categories")
  end
end

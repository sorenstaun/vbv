defmodule VbvWeb.CategoryController do
  use VbvWeb, :controller

  alias Vbv.TaskCategories
  alias Vbv.TaskCategories.Category

  def index(conn, _params) do
    categories = TaskCategories.list_categories(conn.assigns.current_scope)
    render(conn, :index, categories: categories)
  end

  def new(conn, _params) do
    changeset =
      TaskCategories.change_category(conn.assigns.current_scope, %Category{
        user_id: conn.assigns.current_scope.user.id
      })

    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case TaskCategories.create_category(conn.assigns.current_scope, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Task category created successfully.")
        |> redirect(to: ~p"/categories/#{category}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = TaskCategories.get_category!(conn.assigns.current_scope, id)
    render(conn, :show, category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = TaskCategories.get_category!(conn.assigns.current_scope, id)
    changeset = TaskCategories.change_category(conn.assigns.current_scope, category)
    render(conn, :edit, category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = TaskCategories.get_category!(conn.assigns.current_scope, id)

    case TaskCategories.update_category(
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
    category = TaskCategories.get_category!(conn.assigns.current_scope, id)

    {:ok, _category} =
      TaskCategories.delete_category(conn.assigns.current_scope, category)

    conn
    |> put_flash(:info, "Task category deleted successfully.")
    |> redirect(to: ~p"/categories")
  end
end

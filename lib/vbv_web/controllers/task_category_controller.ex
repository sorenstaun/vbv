defmodule VbvWeb.TaskCategoryController do
  use VbvWeb, :controller

  alias Vbv.TaskCategories
  alias Vbv.TaskCategories.TaskCategory

  def index(conn, _params) do
    task_categories = TaskCategories.list_task_categories(conn.assigns.current_scope)
    render(conn, :index, task_categories: task_categories)
  end

  def new(conn, _params) do
    changeset =
      TaskCategories.change_task_category(conn.assigns.current_scope, %TaskCategory{
        user_id: conn.assigns.current_scope.user.id
      })

    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"task_category" => task_category_params}) do
    case TaskCategories.create_task_category(conn.assigns.current_scope, task_category_params) do
      {:ok, task_category} ->
        conn
        |> put_flash(:info, "Task category created successfully.")
        |> redirect(to: ~p"/task_categories/#{task_category}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task_category = TaskCategories.get_task_category!(conn.assigns.current_scope, id)
    render(conn, :show, task_category: task_category)
  end

  def edit(conn, %{"id" => id}) do
    task_category = TaskCategories.get_task_category!(conn.assigns.current_scope, id)
    changeset = TaskCategories.change_task_category(conn.assigns.current_scope, task_category)
    render(conn, :edit, task_category: task_category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task_category" => task_category_params}) do
    task_category = TaskCategories.get_task_category!(conn.assigns.current_scope, id)

    case TaskCategories.update_task_category(
           conn.assigns.current_scope,
           task_category,
           task_category_params
         ) do
      {:ok, task_category} ->
        conn
        |> put_flash(:info, "Task category updated successfully.")
        |> redirect(to: ~p"/task_categories/#{task_category}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, task_category: task_category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task_category = TaskCategories.get_task_category!(conn.assigns.current_scope, id)

    {:ok, _task_category} =
      TaskCategories.delete_task_category(conn.assigns.current_scope, task_category)

    conn
    |> put_flash(:info, "Task category deleted successfully.")
    |> redirect(to: ~p"/task_categories")
  end
end

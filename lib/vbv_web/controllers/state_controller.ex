defmodule VbvWeb.StateController do
  use VbvWeb, :controller

  alias Vbv.States
  alias Vbv.States.State

  def index(conn, _params) do
    states = States.list_states(conn.assigns.current_scope)
    render(conn, :index, states: states)
  end

  def new(conn, _params) do
    changeset =
      States.change_state(conn.assigns.current_scope, %State{
        user_id: conn.assigns.current_scope.user.id
      })

    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"state" => state_params}) do
    case States.create_state(conn.assigns.current_scope, state_params) do
      {:ok, state} ->
        conn
        |> put_flash(:info, "Task state created successfully.")
        |> redirect(to: ~p"/states/#{state}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    state = States.get_state!(conn.assigns.current_scope, id)
    render(conn, :show, state: state)
  end

  def edit(conn, %{"id" => id}) do
    state = States.get_state!(conn.assigns.current_scope, id)
    changeset = States.change_state(conn.assigns.current_scope, state)
    render(conn, :edit, state: state, changeset: changeset)
  end

  def update(conn, %{"id" => id, "state" => state_params}) do
    state = States.get_state!(conn.assigns.current_scope, id)

    case States.update_state(conn.assigns.current_scope, state, state_params) do
      {:ok, state} ->
        conn
        |> put_flash(:info, "Task state updated successfully.")
        |> redirect(to: ~p"/states/#{state}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, state: state, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    state = States.get_state!(conn.assigns.current_scope, id)
    {:ok, _state} = States.delete_state(conn.assigns.current_scope, state)

    conn
    |> put_flash(:info, "Task state deleted successfully.")
    |> redirect(to: ~p"/states")
  end
end

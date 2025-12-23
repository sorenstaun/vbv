defmodule VbvWeb.StateController do
  use VbvWeb, :controller

  alias Vbv.States
  alias Vbv.States.State

  def index(conn, _params) do
    states = States.list_states()
    render(conn, :index, states: states)
  end

  def new(conn, _params) do
    changeset =
      States.change_state(%State{})

    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"state" => state_params}) do
    case States.create_state(state_params) do
      {:ok, state} ->
        conn
        |> put_flash(:info, "Task state created successfully.")
        |> redirect(to: ~p"/states/#{state}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    state = States.get_state!(id)
    render(conn, :show, state: state)
  end

  def edit(conn, %{"id" => id}) do
    state = States.get_state!(id)
    changeset = States.change_state(state)
    render(conn, :edit, state: state, changeset: changeset)
  end

  def update(conn, %{"id" => id, "state" => state_params}) do
    state = States.get_state!(id)

    case States.update_state(conn.assigns.current_scope,state, state_params) do
      {:ok, state} ->
        conn
        |> put_flash(:info, "Task state updated successfully.")
        |> redirect(to: ~p"/states/#{state}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, state: state, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    state = States.get_state!(id)
    {:ok, _state} = States.delete_state(state)

    conn
    |> put_flash(:info, "Task state deleted successfully.")
    |> redirect(to: ~p"/states")
  end
end

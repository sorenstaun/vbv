defmodule Vbv.Context.StateContext do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false

  alias Vbv.Repo
  alias Vbv.States.State

  defp broadcast_state(scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Vbv.PubSub, "user:#{key}:states", message)
  end

  @doc """
  Returns the list of states.

  ## Examples

      iex> list_states(scope)
      [%State{}, ...]

  """
  def list_states(scope) do
    Repo.all_by(State, user_id: scope.user.id)
  end

  @doc """
  Gets a single state.

  Raises `Ecto.NoResultsError` if the Task state does not exist.

  ## Examples

      iex> get_state!(scope, 123)
      %State{}

      iex> get_state!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_state!(scope, id) do
    Repo.get_by!(State, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a state.

  ## Examples

      iex> create_state(scope, %{field: value})
      {:ok, %State{}}

      iex> create_state(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_state(scope, attrs) do
    with {:ok, state = %State{}} <-
           %State{}
           |> State.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_state(scope, {:created, state})
      {:ok, state}
    end
  end

  @doc """
  Updates a state.

  ## Examples

      iex> update_state(scope, state, %{field: new_value})
      {:ok, %State{}}

      iex> update_state(scope, state, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_state(scope, %State{} = state, attrs) do
    true = state.user_id == scope.user.id

    with {:ok, state = %State{}} <-
           state
           |> State.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_state(scope, {:updated, state})
      {:ok, state}
    end
  end

  @doc """
  Deletes a state.

  ## Examples

      iex> delete_state(scope, state)
      {:ok, %State{}}

      iex> delete_state(scope, state)
      {:error, %Ecto.Changeset{}}

  """
  def delete_state(scope, %State{} = state) do
    true = state.user_id == scope.user.id

    with {:ok, state = %State{}} <-
           Repo.delete(state) do
      broadcast_state(scope, {:deleted, state})
      {:ok, state}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking state changes.

  ## Examples

      iex> change_state(scope, state)
      %Ecto.Changeset{data: %State{}}

  """
  def change_state(scope, %State{} = state, attrs \\ %{}) do
    # For new states the user_id is nil — only enforce ownership check
    # when the state already has a user_id.
    if state.user_id != nil do
      true = state.user_id == scope.user.id
    end

    State.changeset(state, attrs, scope)
  end

end

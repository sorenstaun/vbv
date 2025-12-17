defmodule Vbv.States do
  @moduledoc false

  alias Vbv.Context.StateContext
  alias Vbv.States.State

  @doc """
  Subscribes to scoped notifications about any state changes.

  The broadcasted messages match the pattern:

    * {:created, %State{}}
    * {:updated, %State{}}
    * {:deleted, %State{}}

  """
  def subscribe_states(scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Vbv.PubSub, "user:#{key}:states")
  end

  @doc """
  Returns the list of states.

  ## Examples

      iex> list_states(scope)
      [%State{}, ...]

  """
  def list_states(scope) do
    StateContext.list_states(scope)
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
    StateContext.get_state!(scope, id)
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
    StateContext.create_state(scope, attrs)
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
    StateContext.update_state(scope, state, attrs)
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
    StateContext.delete_state(scope, state)
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

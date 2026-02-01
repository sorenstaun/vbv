defmodule VbvWeb.ChangesController do
  use VbvWeb, :controller

  def show(conn, _params) do
    render(conn, :show)
  end
end

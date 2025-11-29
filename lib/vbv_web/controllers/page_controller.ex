defmodule VbvWeb.PageController do
  use VbvWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

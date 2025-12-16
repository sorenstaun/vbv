defmodule VbvWeb.PageController do
  use VbvWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def flowbite(conn, _params) do
    render(conn, :flowbite)
  end
end

defmodule VbvWeb.DevToolsController do
  use VbvWeb, :controller

  def silence(conn, _params) do
    conn
    |> put_status(:no_content)
    |> text("")
  end

  # Alternative :silence function for auto-mapping
  def local(conn, _params) do
    json(conn, %{
      workspace: %{
        # Gets the path to your Phoenix project
        root: File.cwd!(),
        uuid: "your-random-v4-uuid-here"
      }
    })
  end
end

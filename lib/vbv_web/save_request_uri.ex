defmodule VbvWeb.SaveRequestUri do
  import Phoenix.Component

  def on_mount(:save_request_uri, _params, _session, socket) do
    # 1. Initialize the assign so the Layout doesn't crash
    # 2. Attach the hook for future URL changes
    socket =
      socket
      |> assign_new(:current_path, fn -> nil end)
      |> Phoenix.LiveView.attach_hook(
         :save_request_path,
         :handle_params,
         &save_request_path/3
       )

    {:cont, socket}
  end

  def save_request_path(_params, url, socket) do
    IO.inspect(URI.parse(url).path, label: "Saved request path")
    {:cont, assign(socket, :current_path, URI.parse(url).path)}
  end
end

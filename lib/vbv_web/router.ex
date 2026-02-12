defmodule VbvWeb.Router do
  use VbvWeb, :router

  import VbvWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VbvWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VbvWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/flowbite", PageController, :flowbite
  end

  scope "/", VbvWeb do
    pipe_through [:browser, :require_authenticated_user]

    #    resources "/tasks", TaskController
    resources "/categories", CategoryController
    resources "/states", StateController
  end

  scope "/.well-known/appspecific", VbvWeb do
    pipe_through :browser

    get "/com.chrome.devtools.json", DevToolsController, :local
  end

  # Other scopes may use custom stacks.
  # scope "/api", VbvWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:vbv, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VbvWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", VbvWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{VbvWeb.UserAuth, :require_authenticated}, {VbvWeb.SaveRequestUri, :save_request_uri}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
      live "/tasks", TaskLive.Index, :index
      live "/tasks/new", TaskLive.Form, :new
      live "/tasks/:id", TaskLive.Show, :show
      live "/tasks/:id/edit", TaskLive.Form, :edit
      live "/calendar", CalendarLive.Index, :index

      get "/changes", ChangesController, :show
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", VbvWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{VbvWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    get "/users/log-out", UserSessionController, :delete
    delete "/users/log-out", UserSessionController, :delete
  end
end

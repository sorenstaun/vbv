defmodule VbvWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use VbvWeb, :controller
      use VbvWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, formats: [:html, :json]

      use Gettext, backend: VbvWeb.Gettext

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      import PetalComponents

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      import VbvWeb.CoreComponents
      import VbvWeb.Gettext

      # Import PetalComponents so components like <.p> and <.accordion> are available in all templates
      import PetalComponents

      # PetalComponents defines components in submodules (Typography, Accordion, Icon, etc).
      # Import the submodules that provide the HEEx function components used in templates.
      import PetalComponents.Typography,
        only: [p: 1, h1: 1, h2: 1, h3: 1, h4: 1, h5: 1, prose: 1, ol: 1, ul: 1]

      import PetalComponents.Accordion, only: [accordion: 1]
      import PetalComponents.Icon, only: [icon: 1]

      # Alias Layouts so <Layouts.app> works in templates
      alias VbvWeb.Layouts

      # Alias JS for phx-* bindings in templates
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())

      # Petal Components
      defmodule PC do
        defdelegate accordion(assigns), to: PetalComponents.Accordion
        defdelegate alert(assigns), to: PetalComponents.Alert
        defdelegate avatar(assigns), to: PetalComponents.Avatar
        defdelegate badge(assigns), to: PetalComponents.Badge
        defdelegate breadcrumbs(assigns), to: PetalComponents.Breadcrumbs
        defdelegate button(assigns), to: PetalComponents.Button
        defdelegate icon_button(assigns), to: PetalComponents.Button
        defdelegate card(assigns), to: PetalComponents.Card
        defdelegate container(assigns), to: PetalComponents.Container
        defdelegate dropdown(assigns), to: PetalComponents.Dropdown
        defdelegate form_label(assigns), to: PetalComponents.Form
        defdelegate field(assigns), to: PetalComponents.Field
        defdelegate icon(assigns), to: PetalComponents.Icon
        defdelegate input(assigns), to: PetalComponents.Input
        defdelegate a(assigns), to: PetalComponents.Link
        defdelegate spinner(assigns), to: PetalComponents.Loading
        defdelegate modal(assigns), to: PetalComponents.Modal
        defdelegate pagination(assigns), to: PetalComponents.Pagination
        defdelegate progress(assigns), to: PetalComponents.Progress
        defdelegate rating(assigns), to: PetalComponents.Rating
        defdelegate slide_over(assigns), to: PetalComponents.SlideOver
        defdelegate table(assigns), to: PetalComponents.Table
        defdelegate td(assigns), to: PetalComponents.Table
        defdelegate tr(assigns), to: PetalComponents.Table
        defdelegate th(assigns), to: PetalComponents.Table
        defdelegate tabs(assigns), to: PetalComponents.Tabs
        defdelegate h1(assigns), to: PetalComponents.Typography
        defdelegate h2(assigns), to: PetalComponents.Typography
        defdelegate h3(assigns), to: PetalComponents.Typography
        defdelegate h4(assigns), to: PetalComponents.Typography
        defdelegate h5(assigns), to: PetalComponents.Typography
        defdelegate p(assigns), to: PetalComponents.Typography
        defdelegate prose(assigns), to: PetalComponents.Typography
        defdelegate ol(assigns), to: PetalComponents.Typography
        defdelegate ul(assigns), to: PetalComponents.Typography
      end
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: VbvWeb.Endpoint,
        router: VbvWeb.Router,
        statics: VbvWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

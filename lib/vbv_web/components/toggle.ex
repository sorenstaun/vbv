defmodule VbvWeb.Components.Toggle do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <label class="fieldset mb-2">
      <span :if={@label} class="label mb-1">{@label}</span>
      <span
        phx-click={@event_name}
        phx-value-id={@id}
        class={[
          toggle_colour(@toggled),
          "relative inline-flex items-center h-5 w-8 rounded-full cursor-pointer transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 border-2 border-transparent"
        ]}
        role="checkbox"
        tabindex="0"
      >
        <span
          aria-hidden="true"
          class={[
            toggle_position(@toggled),
            "absolute left-0 top-0 h-3 w-3 rounded-full bg-white shadow transform transition duration-200"
          ]}
          style="margin: 2px;"
        >
        </span>
      </span>
      <!-- Hidden input to integrate with forms -->
      <input type="hidden" name={@field && @field.name} value={@toggled && "true" || "false"} id={"#{@id}-hidden"} />
      <!--VbvWeb.CoreComponents.input
        class="visibly-hidden collapse"
        type="checkbox"
        hidden="true"
        field={@field}
      /-->
    </label>
    """
  end

  def toggle_colour(true), do: "bg-green-500"
  def toggle_colour(false), do: "bg-gray-400"

  def toggle_position(true), do: "translate-x-3"
  def toggle_position(false), do: "translate-x-0"
end

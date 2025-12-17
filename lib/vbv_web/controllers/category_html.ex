defmodule VbvWeb.CategoryHTML do
  use VbvWeb, :html

  embed_templates "category_html/*"

  @doc """
  Renders a category form.

  The form is defined in the template at
  category_html/category_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def category_form(assigns)

  def category(assigns) do
    ~H"""
    <.link href={~p"/categories/#{@category.id}"}>
      <div class="flex items-center">
        <span
          role="img"
          aria-label={"Colour: #{@category.colour}"}
          class="w-6 h-6 rounded-full border"
          style={"background-color: #{@category.colour}"}
        />&nbsp; {@category.name}
      </div>
    </.link>
    """
  end
end

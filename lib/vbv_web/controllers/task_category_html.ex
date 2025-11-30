defmodule VbvWeb.TaskCategoryHTML do
  use VbvWeb, :html

  embed_templates "task_category_html/*"

  @doc """
  Renders a task_category form.

  The form is defined in the template at
  task_category_html/task_category_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def task_category_form(assigns)
end

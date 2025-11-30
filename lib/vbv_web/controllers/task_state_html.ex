defmodule VbvWeb.TaskStateHTML do
  use VbvWeb, :html

  embed_templates "task_state_html/*"

  @doc """
  Renders a task_state form.

  The form is defined in the template at
  task_state_html/task_state_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def task_state_form(assigns)
end

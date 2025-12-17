defmodule VbvWeb.TaskHTML do
  use VbvWeb, :html

  embed_templates "task_html/*"

  @doc """
  Renders a task form.

  The form is defined in the template at
  task_html/task_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil
  attr :categories, :list, default: []
  attr :states, :list, default: []

  def task_form(assigns)

  def category(assigns) do
    ~H"""
    <div class="flex items-center">
      <span
        role="img"
        aria-label={"Colour: #{@task.category.colour}"}
        class="w-6 h-6 rounded-full border"
        style={"background-color: #{@task.category.colour}"}
      />&nbsp; {@task.category.name}
    </div>
    """
  end

  def state(assigns) do
    ~H"""
    <div class="flex items-center">
      <span
        role="img"
        aria-label={"Colour: #{@task.state.colour}"}
        class="w-6 h-6 rounded-full border"
        style={"background-color: #{@task.state.colour}"}
      />&nbsp; {@task.state.name}
    </div>
    """
  end


end

defmodule VbvWeb.Components.TaskComponents do

  use Phoenix.Component

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
        class="w-6 h-6 rounded-sm border border-gray-400 bg-gray-200 shadow-[inset_1px_1px_0px_white,inset_-1px_-1px_0px_rgba(0,0,0,0.1)]"
        style={"background-color: #{@task.state.colour}"}
      />&nbsp; {@task.state.name}
    </div>
    """
  end

end

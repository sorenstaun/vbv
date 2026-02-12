defmodule Vbv do
  use Ash.Domain

  resources do
    # Igniter is trying to add these for you:

    resource(Vbv.Category)

    resource(Vbv.State)

    resource Vbv.Task do
      define(:create_task, action: :create)
      define(:read_tasks, action: :read)
      define(:get_task, action: :read, get_by: :id)
      define(:update_task, action: :update)
      define(:delete_task, action: :destroy)
    end

    resource(Vbv.User)

    resource(Vbv.UsersToken)
  end
end

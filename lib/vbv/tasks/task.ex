defmodule Vbv.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :start_date, :date
    field :end_date, :date
    field :start_time, :time
    field :end_time, :time
    field :recurring, :boolean, default: false
    field :user_id, :id
    field :rrule, :string
    field :private, :boolean, default: false
    field :freq, :string
    field :interval, :integer
    field :byday, {:array, :string}

    # Associations

    belongs_to :category, Vbv.Categories.Category
    belongs_to :state, Vbv.States.State

    timestamps(type: :utc_datetime)
  end

  defp calculate_rrule(changeset, _field) do
    recurring = get_field(changeset, :recurring)
    freq = get_field(changeset, :freq)
    interval = get_field(changeset, :interval)

    # get_field will return the list ["MO", "TU", ...]
    byday_list = get_field(changeset, :byday) || []

    if recurring do
      # Build the base string
      base = "RRULE:FREQ=#{freq};INTERVAL=#{interval || 1}"

      # Append BYDAY only if the list isn't empty
      rrule_string =
        if Enum.any?(byday_list) do
          days = Enum.join(byday_list, ",")
          "#{base};BYDAY=#{days}"
        else
          base
        end

      put_change(changeset, :rrule, rrule_string)
    else
      put_change(changeset, :rrule, nil)
    end
  end

  def changeset(task, attrs, user_scope) do
    task
    |> cast(attrs, [
      :name,
      :description,
      :start_date,
      :start_time,
      :end_date,
      :end_time,
      :state_id,
      :category_id,
      :rrule,
      :private,
      :recurring,
      :freq,
      :interval,
      :byday
    ])
    |> validate_required([:name, :description, :start_date])
    # Now that things are cast to proper booleans/integers, calculate:
    |> calculate_rrule(:recurring)
    |> put_change(:user_id, user_scope.user.id)
  end
end

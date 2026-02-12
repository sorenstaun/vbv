defmodule Vbv.Task do
  use Ash.Resource,
    domain: Vbv,
    data_layer: AshPostgres.DataLayer

  actions do
    defaults([:read, :destroy, create: :*, update: :*])
  end

  postgres do
    table("tasks")
    repo(Vbv.Repo)

    references do
      reference :user do
        on_delete(:delete)
      end
    end
  end

  attributes do
    attribute :id, :integer do
      primary_key?(true)
      allow_nil?(false)
      generated?(true)
      public?(true)
    end

    attribute :name, :string do
      public?(true)
    end

    attribute :description, :string do
      public?(true)
    end

    attribute :start_date, :date do
      public?(true)
    end

    attribute :inserted_at, :utc_datetime_usec do
      allow_nil?(false)
      public?(true)
    end

    update_timestamp :updated_at do
      allow_nil?(false)
      public?(true)
    end

    attribute :rrule, :string do
      public?(true)
    end

    attribute :private, :boolean do
      allow_nil?(false)
      sensitive?(true)
      generated?(true)
      public?(true)
    end

    attribute :end_date, :date do
      public?(true)
    end

    attribute :recurring, :boolean do
      allow_nil?(false)
      generated?(true)
      public?(true)
    end

    attribute :start_time, :time do
      public?(true)
    end

    attribute :end_time, :time do
      public?(true)
    end

    attribute :freq, :string do
      public?(true)
    end

    attribute :interval, :integer do
      public?(true)
    end

    attribute :byday, {:array, :string} do
      generated?(true)
      public?(true)
    end
  end

  relationships do
    belongs_to :category, Vbv.Category do
      attribute_type(:integer)
      public?(true)
    end

    belongs_to :state, Vbv.State do
      attribute_type(:integer)
      public?(true)
    end

    belongs_to :user, Vbv.User do
      attribute_type(:integer)
      public?(true)
    end
  end

end

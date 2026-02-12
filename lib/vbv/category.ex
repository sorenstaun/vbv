defmodule Vbv.Category do
  use Ash.Resource,
    domain: Vbv,
    data_layer: AshPostgres.DataLayer

  actions do
    defaults([:read, :destroy, create: :*, update: :*])
  end

  postgres do
    table("categories")
    repo(Vbv.Repo)
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

    attribute :colour, :string do
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
  end

  relationships do
    has_many :tasks, Vbv.Task do
      public?(true)
    end
  end
end

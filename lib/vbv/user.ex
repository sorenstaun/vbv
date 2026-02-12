defmodule Vbv.User do
  use Ash.Resource,
    domain: Vbv,
    data_layer: AshPostgres.DataLayer

  actions do
    defaults([:read, :destroy, create: :*, update: :*])
  end

  postgres do
    table("users")
    repo(Vbv.Repo)

    identity_index_names(email: "users_email_index")
  end

  attributes do
    attribute :id, :integer do
      primary_key?(true)
      allow_nil?(false)
      generated?(true)
      public?(true)
    end

    attribute :email, :ci_string do
      allow_nil?(false)
      sensitive?(true)
      public?(true)
    end

    attribute :hashed_password, :string do
      sensitive?(true)
      public?(true)
    end

    attribute :confirmed_at, :utc_datetime_usec do
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

    attribute :first_name, :string do
      public?(true)
    end

    attribute :last_name, :string do
      public?(true)
    end
  end

  identities do
    identity(:email, [:email])
  end

  relationships do
    has_many :tasks, Vbv.Task do
      public?(true)
    end

    has_many :users_tokens, Vbv.UsersToken do
      public?(true)
    end
  end
end

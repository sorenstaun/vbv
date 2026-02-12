defmodule Vbv.UsersToken do
  use Ash.Resource,
    domain: Vbv,
    data_layer: AshPostgres.DataLayer

  actions do
    defaults([:read, :destroy, create: :*, update: :*])
  end

  postgres do
    table("users_tokens")
    repo(Vbv.Repo)

    references do
      reference :user do
        on_delete(:delete)
      end
    end

    identity_index_names(context_token: "users_tokens_context_token_index")
  end

  attributes do
    attribute :id, :integer do
      primary_key?(true)
      allow_nil?(false)
      generated?(true)
      public?(true)
    end

    attribute :token, :binary do
      allow_nil?(false)
      sensitive?(true)
      public?(true)
    end

    attribute :context, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :sent_to, :string do
      public?(true)
    end

    attribute :authenticated_at, :utc_datetime_usec do
      sensitive?(true)
      public?(true)
    end

    attribute :inserted_at, :utc_datetime_usec do
      allow_nil?(false)
      public?(true)
    end
  end

  identities do
    identity(:context_token, [:context, :token])
  end

  relationships do
    belongs_to :user, Vbv.User do
      allow_nil?(false)
      attribute_type(:integer)
      public?(true)
    end
  end
end

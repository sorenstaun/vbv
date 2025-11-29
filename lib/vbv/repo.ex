defmodule Vbv.Repo do
  use Ecto.Repo,
    otp_app: :vbv,
    adapter: Ecto.Adapters.Postgres
end

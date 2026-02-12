defmodule Vbv.Repo do
  use AshPostgres.Repo,
    otp_app: :vbv,
    adapter: Ecto.Adapters.Postgres

  def installed_extensions do
    # Add "ash-functions" to your existing list
    ["uuid-ossp", "citext", "ash-functions"]
  end

  def min_pg_version do
    %Version{major: 16, minor: 0, patch: 0}
  end
end

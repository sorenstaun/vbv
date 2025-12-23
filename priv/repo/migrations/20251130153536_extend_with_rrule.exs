defmodule Vbv.Repo.Migrations.AddRrulePrivateToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :rrule, :string
      add :private, :boolean, default: true, null: false
    end
  end
end

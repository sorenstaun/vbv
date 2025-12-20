defmodule Vbv.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :rrule, :string
    end
  end
end

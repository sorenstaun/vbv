defmodule Vbv.Repo.Migrations.AddRrulePrivateToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :end_date, :date
      add :recurring, :boolean, default: false, null: false
      add :start_time, :time
      add :end_time, :time
    end

    rename table("tasks"), :start_date, to: :start_date
  end
end

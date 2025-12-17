defmodule Vbv.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :description, :text
      add :deadline, :date
      add :category_id, references(:categories, on_delete: :nothing)
      add :state_id, references(:states, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:user_id])

    create index(:tasks, [:category_id])
    create index(:tasks, [:state_id])
  end
end

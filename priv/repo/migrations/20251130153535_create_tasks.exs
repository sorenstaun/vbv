defmodule Vbv.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :description, :text
      add :deadline, :date
      add :category, references(:task_categories, on_delete: :nothing)
      add :state, references(:task_states, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:user_id])

    create index(:tasks, [:category])
    create index(:tasks, [:state])
  end
end

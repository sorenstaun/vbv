defmodule Vbv.Repo.Migrations.CreateTaskStates do
  use Ecto.Migration

  def change do
    create table(:task_states) do
      add :name, :string
      add :colour, :string
      add :icon, :string
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:task_states, [:user_id])
  end
end

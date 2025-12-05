defmodule Vbv.Repo.Migrations.CreateTaskCategories do
  use Ecto.Migration

  def change do
    create table(:task_categories) do
      add :name, :string
      add :colour, :string
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:task_categories, [:user_id])
  end
end

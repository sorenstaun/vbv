defmodule Vbv.Repo.Migrations.RemoveUserRelations do
  use Ecto.Migration

  def change do
    alter table(:states) do
      remove :user_id
    end
    alter table(:categories) do
      remove :user_id
    end
  end
end

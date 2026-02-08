defmodule Vbv.Repo.Migrations.ExtendWithCalendarFieldsTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :freq, :string
      add :interval, :integer
      add :byday, {:array, :string}, default: []
    end
  end
end

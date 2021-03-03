defmodule Grantland.Repo.Migrations.ChangeProgressToStatusEnumOnGames do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE game_status as ENUM (
      'scheduled', 'in_progress', 'complete', 'canceled', 'other'
    )")

    alter table(:games) do
      remove :progress
      add :status, :game_status
    end
  end

  def down do
    alter table(:games) do
      add :progress, :integer
      remove :status
    end

    execute("DROP TYPE game_status")
  end
end

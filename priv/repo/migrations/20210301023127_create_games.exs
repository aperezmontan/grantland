defmodule Grantland.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :home_team, :integer
      add :away_team, :integer
      add :home_score, :integer
      add :away_score, :integer
      add :progress, :integer
      add :time, :utc_datetime

      timestamps()
    end

  end
end

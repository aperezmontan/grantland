defmodule Grantland.Repo.Migrations.CreateGamesRounds do
  use Ecto.Migration

  def change do
    create table(:games_rounds) do
      add :game_id, references(:games, on_delete: :delete_all)
      add :round_id, references(:rounds, on_delete: :delete_all)
    end

    create unique_index(:games_rounds, [:game_id, :round_id])
  end
end

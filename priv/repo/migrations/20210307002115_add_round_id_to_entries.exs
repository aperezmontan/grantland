defmodule Grantland.Repo.Migrations.AddRoundIdToEntries do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      remove :round
      add :round_id, references(:rounds)
    end
  end
end

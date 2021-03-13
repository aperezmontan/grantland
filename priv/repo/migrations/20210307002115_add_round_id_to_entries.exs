defmodule Grantland.Repo.Migrations.AddRoundIdToEntries do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      remove :round
    end
  end
end

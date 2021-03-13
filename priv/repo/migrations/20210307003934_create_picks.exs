defmodule Grantland.Repo.Migrations.CreatePicks do
  use Ecto.Migration

  def change do
    create table(:picks) do
      # Create a custome Ecto.Type called Selection
      # We'll use this field to autoload the requisite selection (whether that's a team, number, etc.)
      add :selection, :map
      add :entry_id, references(:entries, on_delete: :delete_all)
      add :round_id, references(:rounds, on_delete: :delete_all)

      timestamps()
    end
  end
end

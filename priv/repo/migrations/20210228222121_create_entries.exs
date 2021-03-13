defmodule Grantland.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :name, :string
      add :round, :integer
      add :pool_id, references(:pools, on_delete: :delete_all)

      timestamps()
    end

    create index(:entries, [:pool_id])
  end
end

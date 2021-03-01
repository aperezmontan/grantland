defmodule Grantland.Repo.Migrations.AddUniqueIndexToNameOnEntriesTable do
  use Ecto.Migration

  def change do
    create unique_index(:entries, [:name, :pool_id])
  end
end

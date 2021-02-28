defmodule Grantland.Repo.Migrations.AddUniqueIndexToNameOnPoolsTable do
  use Ecto.Migration

  def change do
    create unique_index(:pools, [:name])
  end
end

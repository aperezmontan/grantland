defmodule Grantland.Repo.Migrations.AddTypeToPool do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE pool_types as ENUM (
      'box', 'knockout'
    )")

    alter table(:pools) do
      add :type, :pool_types
    end
  end

  def down do
    alter table(:pools) do
      remove :type
    end

    execute("DROP TYPE pool_types")
  end
end

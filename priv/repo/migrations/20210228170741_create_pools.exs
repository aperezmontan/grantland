defmodule Grantland.Repo.Migrations.CreatePools do
  use Ecto.Migration

  def change do
    create table(:pools) do
      add :name, :string

      timestamps()
    end

  end
end

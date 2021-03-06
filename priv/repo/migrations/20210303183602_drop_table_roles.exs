defmodule Grantland.Repo.Migrations.DropTableRoles do
  use Ecto.Migration

  def up do
    drop table(:roles)
  end

  def down do
    create table(:roles) do
      add :name, :string

      timestamps()
    end
  end
end

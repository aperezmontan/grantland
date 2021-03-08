defmodule Grantland.Repo.Migrations.CreateRounds do
  use Ecto.Migration

  def change do
    create table(:rounds) do
      add :number, :integer
      add :name, :string
      add :pool_id, references(:pools)

      timestamps()
    end
  end
end

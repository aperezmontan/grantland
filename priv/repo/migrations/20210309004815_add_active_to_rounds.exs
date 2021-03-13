defmodule Grantland.Repo.Migrations.AddActiveToRounds do
  use Ecto.Migration

  def change do
    alter table(:rounds) do
      add :active, :boolean
    end
  end
end

defmodule Grantland.Repo.Migrations.AddUserIdToEntries do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :user_id, references(:users)
    end
  end
end

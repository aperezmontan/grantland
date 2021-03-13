defmodule Grantland.Repo.Migrations.AddUserIdToEntries do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end

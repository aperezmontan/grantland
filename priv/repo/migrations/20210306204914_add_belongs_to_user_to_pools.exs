defmodule Grantland.Repo.Migrations.AddBelongsToUserToPools do
  use Ecto.Migration

  def change do
    alter table(:pools) do
      add :user_id, references(:users)
    end
  end
end

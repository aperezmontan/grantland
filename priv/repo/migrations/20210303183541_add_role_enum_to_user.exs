defmodule Grantland.Repo.Migrations.AddRoleEnumToUser do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE user_roles as ENUM (
      'admin', 'moderator', 'user', 'guest'
    )")

    alter table(:users) do
      remove :role_id
      add :role, :user_roles
    end
  end

  def down do
    alter table(:users) do
      add :role_id, references(:roles, on_delete: :nothing)
      remove :role
    end

    execute("DROP TYPE user_roles")
  end
end

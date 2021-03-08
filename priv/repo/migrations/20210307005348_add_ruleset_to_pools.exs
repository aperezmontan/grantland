defmodule Grantland.Repo.Migrations.AddRulesetToPools do
  use Ecto.Migration

  def change do
    alter table(:pools) do
      # Create a custome Ecto.Type called Selection
      # We'll use this field to autoload the requisite selection (whether that's a team, number, etc.)
      add :ruleset, :map
    end
  end
end

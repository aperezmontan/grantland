defmodule Grantland.Engine.Pool do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pools" do
    field :name, :string
    field :ruleset, Grantland.Engine.EctoRuleset, default: Grantland.Engine.Ruleset.new()

    belongs_to :user, Grantland.Identity.User

    timestamps()
  end

  @doc false
  def changeset(pool, attrs) do
    pool
    |> cast(attrs, [:ruleset, :name, :user_id])
    |> validate_required([:ruleset, :name, :user_id])
    |> validate_length(:name, min: 3)
    |> unique_constraint(:name)
  end
end

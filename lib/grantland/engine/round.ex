defmodule Grantland.Engine.Round do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rounds" do
    field :number, :integer, default: 0
    field :name, :string

    belongs_to :pool, Grantland.Engine.Round
    many_to_many :games, Grantland.Data.Game, join_through: "games_rounds"

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:name, :number, :pool_id])
    |> validate_required([:number, :pool_id])
    |> unique_constraint([:number, :pool_id])
    |> validate_number(:number, greater_than_or_equal_to: 0)
  end
end

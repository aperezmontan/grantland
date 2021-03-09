defmodule Grantland.Engine.Round do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rounds" do
    field :number, :integer, default: 1
    field :name, :string

    belongs_to :pool, Grantland.Engine.Pool
    many_to_many :games, Grantland.Data.Game, join_through: "games_rounds", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(round, attrs) do
    round
    |> cast(attrs, [:name, :number, :pool_id])
    |> validate_required([:number, :pool_id])
    |> unique_constraint([:number, :pool_id])
    |> validate_number(:number, greater_than_or_equal_to: 0)
  end

  def changeset_update_games(round, games) do
    round
    |> change()
    # associate games to the round
    |> put_assoc(:games, games)
  end
end

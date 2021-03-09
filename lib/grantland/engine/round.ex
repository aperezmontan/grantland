defmodule Grantland.Engine.Round do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias __MODULE__
  alias Grantland.Engine

  schema "rounds" do
    field :number, :integer, default: 1
    field :name, :string
    field :active, :boolean, default: false

    belongs_to :pool, Grantland.Engine.Pool
    many_to_many :games, Grantland.Data.Game, join_through: "games_rounds", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(round, attrs) do
    round
    |> cast(attrs, [:name, :number, :pool_id, :active])
    |> validate_required([:number, :pool_id, :active])
    |> unique_constraint([:number, :pool_id])
    |> validate_number(:number, greater_than_or_equal_to: 1)
    |> maybe_validate_only_active_round(round.pool_id)
  end

  def changeset_update_games(round, games) do
    round
    |> change()
    # associate games to the round
    |> put_assoc(:games, games)
  end

  defp maybe_validate_only_active_round(%{changes: changes} = changeset, pool_id) do
    case Map.has_key?(changes, :active) && changes.active do
      true -> validate_only_active_round_in_pool(changeset, pool_id)
      false -> changeset
    end
  end

  defp validate_only_active_round_in_pool(changeset, pool_id) do
    pool_id = changeset.changes[:pool_id] || pool_id

    case Engine.get_active_round_in_pool(pool_id) do
      %Round{} -> add_error(changeset, :active, "Pool already has an active round")
      nil -> changeset
      error -> error
    end
  end
end

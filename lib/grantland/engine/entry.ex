defmodule Grantland.Engine.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  alias Grantland.Engine.Pool

  schema "entries" do
    field :name, :string
    field :round, :integer, default: 1

    belongs_to :pool, Pool

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:name, :pool_id, :round])
    |> validate_required([:name, :pool_id])
    |> unique_constraint([:name, :pool_id])
  end
end

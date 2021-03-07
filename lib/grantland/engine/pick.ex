defmodule Grantland.Engine.Pick do
  use Ecto.Schema
  import Ecto.Changeset

  schema "picks" do
    field :selection, :map

    belongs_to :entry, Grantland.Engine.Entry
    belongs_to :round, Grantland.Engine.Round

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:selection, :entry_id, :round_id])
    |> validate_required([:entry_id, :round_id])
    |> unique_constraint([:selection, :round_id])
  end
end

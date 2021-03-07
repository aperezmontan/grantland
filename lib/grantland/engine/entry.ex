defmodule Grantland.Engine.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :name, :string

    belongs_to :pool, Grantland.Engine.Pool
    belongs_to :user, Grantland.Identity.User

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:name, :pool_id, :user_id])
    |> validate_required([:name, :pool_id, :user_id])
    |> unique_constraint([:name, :pool_id])
  end
end

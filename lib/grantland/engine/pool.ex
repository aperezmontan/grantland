defmodule Grantland.Engine.Pool do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pools" do
    field :name, :string
    belongs_to :user, Grantland.Identity.User

    timestamps()
  end

  @doc false
  def changeset(pool, attrs) do
    pool
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> validate_length(:name, min: 3)
    |> unique_constraint(:name)
  end
end

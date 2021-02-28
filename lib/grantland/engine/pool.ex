defmodule Grantland.Engine.Pool do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pools" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(pool, attrs) do
    pool
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 3)
    |> unique_constraint(:name)
  end
end

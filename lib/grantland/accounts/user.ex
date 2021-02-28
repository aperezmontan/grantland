defmodule Grantland.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Grantland.Accounts.Role

  schema "users" do
    field :name, :string

    belongs_to :role, Role

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :role_id])
    |> validate_required([:name, :role_id])
    |> validate_length(:name, min: 3)
    |> unique_constraint(:name)
  end
end

defmodule Grantland.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string

    field :role, Ecto.Enum,
      values: [
        :admin,
        :moderator,
        :user,
        :guest
      ],
      default: :guest

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :role])
    |> validate_required([:name, :role])
    |> validate_length(:name, min: 3)
    |> unique_constraint(:name)
  end
end

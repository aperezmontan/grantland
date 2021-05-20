defmodule Grantland.Engine.Pool do
  use Ecto.Schema
  import Ecto.Changeset

  alias Grantland.Engine.Ruleset

  schema "pools" do
    field :name, :string

    embeds_one :ruleset, Ruleset, on_replace: :update do
      # TODO: check if these defaults and mins are actually respected. Probably just using the defstruct in Ruleset
      field :state, Ecto.Enum,
        values: Ruleset.valid_pool_states(),
        default: :initialized

      field :pool_type, Ecto.Enum,
        values: Ruleset.valid_pool_types(),
        default: :knockout

      field :rounds, :integer, min: 1, default: 1
      field :picks_per_round, :map, default: %{}
    end

    belongs_to :user, Grantland.Identity.User
    has_many :entries, Grantland.Engine.Entry
    has_many :rounds, Grantland.Engine.Round
    has_many :picks, through: [:entries, :picks]

    timestamps()
  end

  @doc false
  def changeset(pool, attrs) do
    pool
    |> cast(attrs, [:name, :user_id])
    |> cast_embed(:ruleset, with: &ruleset_changeset/2)
    |> cast_assoc(:entries)
    |> validate_required([:ruleset, :name, :user_id])
    |> validate_length(:name, min: 3)
    |> unique_constraint(:name)
  end

  @doc false
  defp ruleset_changeset(schema, params) do
    params =
      case is_struct(params) do
        true -> Map.from_struct(params)
        false -> params
      end

    schema |> Ruleset.changeset(params)
  end
end

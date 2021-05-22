defmodule Grantland.Engine.Ruleset do
  import Ecto.Changeset

  alias __MODULE__

  @valid_pool_states [:initialized, :in_progress, :completed]
  @valid_pool_types [:box, :knockout]

  defstruct state: :initialized,
            pool_type: :knockout,
            # TODO: remove this. Should get number of rounds from picks_per_round
            rounds: 1,
            picks_per_round: %{"round_1" => 1}

  def new(attrs \\ %{}), do: struct(Ruleset, attrs)

  def valid_actions, do: [:add_entry, :start_pool, :complete_pool]
  def valid_pool_states, do: @valid_pool_states
  def valid_pool_types, do: @valid_pool_types

  # THE ECTO STUFF
  use Ecto.Type

  def type, do: :map

  # Accept casting of Ruleset structs
  def cast(%Ruleset{} = ruleset), do: {:ok, ruleset}

  # Everything else is a failure though
  def cast(_), do: :error

  # When loading data from the database, as long as it's a map,
  # we just put the data back into a Ruleset struct to be stored in
  # the loaded schema struct.
  def load(data) when is_map(data) do
    data =
      for {key, val} <- data do
        # TODO: This is how we return atom values. Clean this up.
        val =
          case key == "pool_type" || key == "state" do
            true -> String.to_existing_atom(val)
            false -> val
          end

        {String.to_existing_atom(key), val}
      end

    {:ok, struct!(Ruleset, data)}
  end

  # When dumping data to the database, we *expect* a Ruleset struct
  # but any value could be inserted into the schema struct at runtime,
  # so we need to guard against them.
  def dump(%Ruleset{} = ruleset), do: {:ok, Map.from_struct(ruleset)}
  def dump(_), do: :error

  @doc false
  def changeset(ruleset \\ %Ruleset{}, attrs) do
    ruleset
    |> cast(attrs, [:state, :pool_type, :picks_per_round])
    |> validate_required([:state, :pool_type, :picks_per_round])
    |> validate_inclusion(:state, @valid_pool_states)
    |> validate_inclusion(:pool_type, @valid_pool_types)
    |> maybe_validate_picks_per_round(ruleset)
  end

  defp maybe_validate_picks_per_round(%{changes: changes} = changeset, ruleset) do
    case Map.has_key?(changes, :picks_per_round) do
      true -> validate_picks_per_round(changeset, ruleset)
      false -> changeset
    end
  end

  defp validate_picks_per_round(%{changes: changes} = changeset, ruleset) do
    picks_per_round = changes[:picks_per_round] || ruleset.picks_per_round

    case check_picks_per_round(picks_per_round) do
      true -> changeset
      false -> add_error(changeset, :picks_per_round, "Is incorrect")
    end
  end

  defp check_picks_per_round(picks_per_round) do
    Enum.all?(Map.values(picks_per_round), fn picks ->
      picks_number_valid?(picks)
    end)
  end

  defp picks_number_valid?(picks) do
    (is_integer(picks) && picks > 0) || (is_bitstring(picks) && parsed_pick(picks) > 0)
  end

  defp parsed_pick(picks) do
    case Integer.parse(picks) do
      {integer, ""} -> integer
      :error -> 0
    end
  end
end

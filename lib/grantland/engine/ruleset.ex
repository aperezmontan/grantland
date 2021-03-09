defmodule Grantland.Engine.Ruleset do
  alias __MODULE__

  @valid_pool_states [:initialized, :in_progress, :completed]
  @valid_pool_types [:box, :knockout]

  defstruct state: :initialized,
            pool_type: :knockout,
            rounds: 0

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
end

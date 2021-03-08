defmodule Grantland.Engine.Ruleset do
  alias __MODULE__

  defstruct state: :initialized,
            pool_type: :suicide,
            rounds: 0

  def new(attrs \\ %{}), do: struct(Ruleset, attrs)

  def check(%Ruleset{state: :initialized} = ruleset, :start_pool) do
    {:ok, %Ruleset{ruleset | state: :in_progress}}
  end

  def check(%Ruleset{state: :in_progress} = ruleset, :start_pool) do
    {:ok, ruleset}
  end

  def check(%Ruleset{} = ruleset, :complete_pool) do
    {:ok, %Ruleset{ruleset | state: :completed}}
  end

  def check(%Ruleset{state: :initialized} = ruleset, :add_entry), do: {:ok, ruleset}

  def check(%Ruleset{state: :in_progress}, :add_entry),
    do: {:error, "Entry cannot be added. Pool's already started."}

  def check(%Ruleset{state: :completed}, _action),
    do: {:error, "Pool cannot be updated. It's complete."}

  def valid_actions, do: [:add_entry, :start_pool, :complete_pool]
  def valid_pool_types, do: [:box, :suicide]
end

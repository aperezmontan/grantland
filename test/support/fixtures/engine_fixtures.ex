defmodule Grantland.EngineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Grantland.Engine` context.
  """

  import Grantland.IdentityFixtures

  def unique_entry_name, do: "entry#{System.unique_integer()}"
  def unique_pool_name, do: "pool#{System.unique_integer()}"

  def entry_fixture(attrs \\ %{}) do
    %Grantland.Identity.User{id: user_id} = user_fixture()
    %Grantland.Engine.Pool{id: pool_id} = pool_fixture()

    {:ok, entry} =
      attrs
      |> Enum.into(%{
        name: unique_entry_name(),
        pool_id: pool_id,
        user_id: user_id
      })
      |> Grantland.Engine.create_entry()

    entry
  end

  def pick_fixture(attrs \\ %{}) do
    %Grantland.Engine.Entry{id: entry_id} = entry_fixture()
    %Grantland.Engine.Round{id: round_id} = round_fixture()

    {:ok, pick} =
      attrs
      |> Enum.into(%{
        entry_id: entry_id,
        round_id: round_id
      })
      |> Grantland.Engine.create_pick()

    pick
  end

  def pool_fixture(attrs \\ %{}) do
    %Grantland.Identity.User{id: user_id} = user_fixture()

    attrs =
      case Map.has_key?(attrs, :ruleset) do
        true -> attrs
        false -> attrs |> Enum.into(%{ruleset: ruleset_fixture()})
      end

    {:ok, pool} =
      attrs
      |> Enum.into(%{
        name: unique_pool_name(),
        user_id: user_id
      })
      |> Grantland.Engine.create_pool()

    pool
  end

  def round_fixture(attrs \\ %{}) do
    %Grantland.Engine.Pool{id: pool_id} = pool_fixture()

    {:ok, round} =
      attrs
      |> Enum.into(%{pool_id: pool_id})
      |> Grantland.Engine.create_round()

    round
  end

  def ruleset_fixture(attrs \\ %{}) do
    Grantland.Engine.create_ruleset(attrs)
  end
end

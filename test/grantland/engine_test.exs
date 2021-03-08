defmodule Grantland.EngineTest do
  use Grantland.DataCase

  import Grantland.{EngineFixtures, IdentityFixtures}

  alias Grantland.Engine
  alias Grantland.Engine.{Entry, Pick, Pool, Round, Ruleset}

  describe "entries" do
    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Engine.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Engine.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      %Pool{id: pool_id} = pool_fixture()
      %Grantland.Identity.User{id: user_id} = user_fixture()

      assert {:ok, %Entry{} = entry} =
               @valid_attrs
               |> Enum.into(%{pool_id: pool_id, user_id: user_id})
               |> Engine.create_entry()

      assert entry.name == "some name"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Engine.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{} = entry} = Engine.update_entry(entry, @update_attrs)
      assert entry.name == "some updated name"
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Engine.update_entry(entry, @invalid_attrs)
      assert entry == Engine.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Engine.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Engine.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Engine.change_entry(entry)
    end
  end

  describe "picks" do
    @valid_attrs %{selection: %{"foo" => :bar}}
    @update_attrs %{selection: %{"fizz" => :buzz}}
    @invalid_attrs %{round_id: nil}

    test "list_picks/0 returns all picks" do
      pick = pick_fixture()
      assert Engine.list_picks() == [pick]
    end

    test "get_pick!/1 returns the pick with given id" do
      pick = pick_fixture()
      assert Engine.get_pick!(pick.id) == pick
    end

    test "create_pick/1 with valid data creates a pick" do
      %Entry{id: entry_id} = entry_fixture()
      %Round{id: round_id} = round_fixture()

      assert {:ok, %Pick{} = pick} =
               @valid_attrs
               |> Enum.into(%{entry_id: entry_id, round_id: round_id})
               |> Engine.create_pick()

      assert pick.selection == %{"foo" => :bar}
    end

    test "create_pick/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Engine.create_pick(@invalid_attrs)
    end

    test "update_pick/2 with valid data updates the pick" do
      pick = pick_fixture()
      assert {:ok, %Pick{} = pick} = Engine.update_pick(pick, @update_attrs)
      assert pick.selection == %{"fizz" => :buzz}
    end

    test "update_pick/2 with invalid data returns error changeset" do
      pick = pick_fixture()
      assert {:error, %Ecto.Changeset{}} = Engine.update_pick(pick, @invalid_attrs)
      assert pick == Engine.get_pick!(pick.id)
    end

    test "delete_pick/1 deletes the pick" do
      pick = pick_fixture()
      assert {:ok, %Pick{}} = Engine.delete_pick(pick)
      assert_raise Ecto.NoResultsError, fn -> Engine.get_pick!(pick.id) end
    end

    test "change_pick/1 returns a pick changeset" do
      pick = pick_fixture()
      assert %Ecto.Changeset{} = Engine.change_pick(pick)
    end
  end

  describe "pools" do
    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_pools/0 returns all pools" do
      pool = pool_fixture()
      assert Engine.list_pools() == [pool]
    end

    test "get_pool!/1 returns the pool with given id" do
      pool = pool_fixture()
      assert Engine.get_pool!(pool.id) == pool
    end

    test "create_pool/1 with valid data creates a pool" do
      %Grantland.Identity.User{id: user_id} = user_fixture()

      assert {:ok, %Pool{} = pool} =
               @valid_attrs |> Enum.into(%{user_id: user_id}) |> Engine.create_pool()

      assert pool.name == "some name"
    end

    test "create_pool/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Engine.create_pool(@invalid_attrs)
    end

    test "update_pool/2 with valid data updates the pool" do
      pool = pool_fixture()
      assert {:ok, %Pool{} = pool} = Engine.update_pool(pool, @update_attrs)
      assert pool.name == "some updated name"
    end

    test "update_pool/2 with invalid data returns error changeset" do
      pool = pool_fixture()
      assert {:error, %Ecto.Changeset{}} = Engine.update_pool(pool, @invalid_attrs)
      assert pool == Engine.get_pool!(pool.id)
    end

    test "delete_pool/1 deletes the pool" do
      pool = pool_fixture()
      assert {:ok, %Pool{}} = Engine.delete_pool(pool)
      assert_raise Ecto.NoResultsError, fn -> Engine.get_pool!(pool.id) end
    end

    test "change_pool/1 returns a pool changeset" do
      pool = pool_fixture()
      assert %Ecto.Changeset{} = Engine.change_pool(pool)
    end
  end

  describe "rounds" do
    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{number: nil}

    test "list_rounds/0 returns all rounds" do
      round = round_fixture()
      assert Engine.list_rounds() == [round]
    end

    test "get_round!/1 returns the round with given id" do
      round = round_fixture()
      assert Engine.get_round!(round.id) == round
    end

    test "create_round/1 with valid data creates a round" do
      %Pool{id: pool_id} = pool_fixture()
      %Grantland.Identity.User{id: user_id} = user_fixture()

      assert {:ok, %Round{} = round} =
               @valid_attrs
               |> Enum.into(%{pool_id: pool_id, user_id: user_id})
               |> Engine.create_round()

      assert round.name == "some name"
    end

    test "create_round/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Engine.create_round(@invalid_attrs)
    end

    test "update_round/2 with valid data updates the round" do
      round = round_fixture()
      assert {:ok, %Round{} = round} = Engine.update_round(round, @update_attrs)
      assert round.name == "some updated name"
    end

    test "update_round/2 with invalid data returns error changeset" do
      round = round_fixture()
      assert {:error, %Ecto.Changeset{}} = Engine.update_round(round, @invalid_attrs)
      assert round == Engine.get_round!(round.id)
    end

    test "delete_round/1 deletes the round" do
      round = round_fixture()
      assert {:ok, %Round{}} = Engine.delete_round(round)
      assert_raise Ecto.NoResultsError, fn -> Engine.get_round!(round.id) end
    end

    test "change_round/1 returns a round changeset" do
      round = round_fixture()
      assert %Ecto.Changeset{} = Engine.change_round(round)
    end
  end

  describe "rulesets" do
    @default_attrs %{state: :initialized, pool_type: :suicide, rounds: 0}

    test "new/0 returns a new Ruleset with default data" do
      assert %Ruleset{} = ruleset = ruleset_fixture()
      assert ruleset.state == @default_attrs.state
      assert ruleset.pool_type == @default_attrs.pool_type
      assert ruleset.rounds == @default_attrs.rounds
    end

    test "new/1 returns a new Ruleset with entered data" do
      assert %Ruleset{} = ruleset = ruleset_fixture(%{state: :completed})
      assert ruleset.state == :completed
      assert ruleset.pool_type == @default_attrs.pool_type
      assert ruleset.rounds == @default_attrs.rounds
    end

    test "check_pool_ruleset/2 when trying to update the pool's state to :in_progress, when the pool is :initialized, it returns the Pool with state set to :in_progress" do
      pool = pool_fixture()
      assert pool.ruleset.state == :initialized

      assert {:ok, %Pool{ruleset: %Ruleset{state: :in_progress}}} =
               Engine.check_pool_ruleset(pool, :start_pool)
    end

    test "check_pool_ruleset/2 when trying to update the pool's state to :completed, when the pool is :initialized, it returns the Pool with state set to :in_progress" do
      pool = pool_fixture()
      assert pool.ruleset.state == :initialized

      assert {:ok, %Pool{ruleset: %Ruleset{state: :completed}}} =
               Engine.check_pool_ruleset(pool, :complete_pool)
    end

    test "check_pool_ruleset/2 when trying to update the pool's state to :completed, when the pool is :initialized, it returns the Pool with state set to :completed" do
      pool = pool_fixture()
      assert pool.ruleset.state == :initialized

      assert {:ok, %Pool{ruleset: %Ruleset{state: :completed}}} =
               Engine.check_pool_ruleset(pool, :complete_pool)
    end

    test "check_pool_ruleset/2 when trying to update the pool's state to :in_progress, when the pool is :in_progress, it returns the Pool with state set to :in_progress" do
      ruleset = ruleset_fixture(%{state: :in_progress})
      pool = pool_fixture(%{ruleset: ruleset})
      assert pool.ruleset.state == :in_progress

      assert {:ok, %Pool{ruleset: %Ruleset{state: :in_progress}}} =
               Engine.check_pool_ruleset(pool, :start_pool)
    end

    test "check_pool_ruleset/2 when trying to update the pool's state to :completed, when the pool is :in_progress, it returns the Pool with state set to :in_progress" do
      ruleset = ruleset_fixture(%{state: :in_progress})
      pool = pool_fixture(%{ruleset: ruleset})
      assert pool.ruleset.state == :in_progress

      assert {:ok, %Pool{ruleset: %Ruleset{state: :completed}}} =
               Engine.check_pool_ruleset(pool, :complete_pool)
    end

    test "check_pool_ruleset/2 when trying to update the pool's state to :completed, when the pool is :in_progress, it returns the Pool with state set to :completed" do
      ruleset = ruleset_fixture(%{state: :in_progress})
      pool = pool_fixture(%{ruleset: ruleset})
      assert pool.ruleset.state == :in_progress

      assert {:ok, %Pool{ruleset: %Ruleset{state: :completed}}} =
               Engine.check_pool_ruleset(pool, :complete_pool)
    end

    test "check_pool_ruleset/2 when trying to update the pool's state to :completed, when the pool is :initialized or :in_progress, it always returns completed" do
      initialized_ruleset = ruleset_fixture()
      in_progress_ruleset = ruleset_fixture(%{state: :in_progress})
      initialized_pool = pool_fixture(%{ruleset: initialized_ruleset})
      in_progress_pool = pool_fixture(%{ruleset: in_progress_ruleset})

      assert initialized_pool.ruleset.state == :initialized
      assert in_progress_pool.ruleset.state == :in_progress

      assert {:ok, %Pool{ruleset: %Ruleset{state: :completed}}} =
               Engine.check_pool_ruleset(initialized_pool, :complete_pool)

      assert {:ok, %Pool{ruleset: %Ruleset{state: :completed}}} =
               Engine.check_pool_ruleset(in_progress_pool, :complete_pool)
    end

    test "check_pool_ruleset/2 when trying to update the pool's state when it's completed returns an error" do
      ruleset = ruleset_fixture(%{state: :completed})
      pool = pool_fixture(%{ruleset: ruleset})

      assert {:error, "Pool cannot be updated. It's complete."} =
               Engine.check_pool_ruleset(pool, :start_pool)
    end

    test "check_pool_ruleset/2 when trying to update a Ruleset with an invalid action returns an error" do
      pool = pool_fixture()

      assert {:error, :invalid_action} = Engine.check_pool_ruleset(pool, :foo)
    end
  end
end

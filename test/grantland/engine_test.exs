defmodule Grantland.EngineTest do
  use Grantland.DataCase

  alias Grantland.Engine

  describe "pools" do
    alias Grantland.Engine.Pool

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def pool_fixture(attrs \\ %{}) do
      {:ok, pool} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Engine.create_pool()

      pool
    end

    test "list_pools/0 returns all pools" do
      pool = pool_fixture()
      assert Engine.list_pools() == [pool]
    end

    test "get_pool!/1 returns the pool with given id" do
      pool = pool_fixture()
      assert Engine.get_pool!(pool.id) == pool
    end

    test "create_pool/1 with valid data creates a pool" do
      assert {:ok, %Pool{} = pool} = Engine.create_pool(@valid_attrs)
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

  describe "entries" do
    alias Grantland.Engine.Entry

    @valid_attrs %{name: "some name", round: 42}
    @update_attrs %{name: "some updated name", round: 43}
    @invalid_attrs %{name: nil, round: nil}

    def entry_fixture(attrs \\ %{}) do
      {:ok, entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Engine.create_entry()

      entry
    end

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Engine.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Engine.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      assert {:ok, %Entry{} = entry} = Engine.create_entry(@valid_attrs)
      assert entry.name == "some name"
      assert entry.round == 42
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Engine.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{} = entry} = Engine.update_entry(entry, @update_attrs)
      assert entry.name == "some updated name"
      assert entry.round == 43
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
end

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
end

defmodule GrantlandWeb.PoolLiveTest do
  use GrantlandWeb.ConnCase

  import Phoenix.LiveViewTest
  import Grantland.{DataFixtures, EngineFixtures, IdentityFixtures}

  alias Grantland.Engine

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_pool(_) do
    pool = pool_fixture()
    %{pool: pool}
  end

  describe "Index" do
    setup [:create_pool]

    test "lists all pools", %{conn: conn, pool: pool} do
      {:ok, _index_live, html} = live(conn, Routes.pool_index_path(conn, :index))

      assert html =~ "Listing Pools"
      assert html =~ pool.name
    end

    test "saves new pool", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.pool_index_path(conn, :index))

      assert index_live |> element("a", "New Pool") |> render_click() =~
               "New Pool"

      assert_patch(index_live, Routes.pool_index_path(conn, :new))

      assert index_live
             |> form("#pool-form", pool: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#pool-form", pool: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.pool_index_path(conn, :index))

      assert html =~ "Pool created successfully"
      assert html =~ "some name"
    end

    test "updates pool in listing", %{conn: conn, pool: pool} do
      {:ok, index_live, _html} = live(conn, Routes.pool_index_path(conn, :index))

      assert index_live |> element("#pool-#{pool.id} a", "Edit") |> render_click() =~
               "Edit Pool"

      assert_patch(index_live, Routes.pool_index_path(conn, :edit, pool))

      assert index_live
             |> form("#pool-form", pool: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#pool-form", pool: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.pool_index_path(conn, :index))

      assert html =~ "Pool updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes pool in listing", %{conn: conn, pool: pool} do
      {:ok, index_live, _html} = live(conn, Routes.pool_index_path(conn, :index))

      assert index_live |> element("#pool-#{pool.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#pool-#{pool.id}")
    end
  end

  describe "Show" do
    setup [:create_pool]

    test "displays pool", %{conn: conn, pool: pool} do
      {:ok, _show_live, html} = live(conn, Routes.pool_show_path(conn, :show, pool))

      assert html =~ "Show Pool"
      assert html =~ pool.name
    end

    test "updates pool within modal", %{conn: conn, pool: pool} do
      {:ok, show_live, _html} = live(conn, Routes.pool_show_path(conn, :show, pool))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Pool"

      assert_patch(show_live, Routes.pool_show_path(conn, :edit, pool))

      assert show_live
             |> form("#pool-form", pool: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#pool-form", pool: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.pool_show_path(conn, :show, pool))

      assert html =~ "Pool updated successfully"
      assert html =~ "some updated name"
    end
  end
end

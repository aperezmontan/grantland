defmodule GrantlandWeb.PoolLive.Index do
  use GrantlandWeb, :live_view

  alias Grantland.Engine
  alias Grantland.Engine.Pool

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok, assign(socket, :pools, list_pools())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Pool")
    |> assign(:pool, Engine.get_pool!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Pool")
    |> assign(:pool, %Pool{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Pools")
    |> assign(:pool, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pool = Engine.get_pool!(id)
    {:ok, _} = Engine.delete_pool(pool)

    {:noreply, assign(socket, :pools, list_pools())}
  end

  defp list_pools do
    Engine.list_pools()
  end
end

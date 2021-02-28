defmodule GrantlandWeb.PoolLive.Show do
  use GrantlandWeb, :live_view

  alias Grantland.Engine

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:pool, Engine.get_pool!(id))}
  end

  defp page_title(:show), do: "Show Pool"
  defp page_title(:edit), do: "Edit Pool"
end

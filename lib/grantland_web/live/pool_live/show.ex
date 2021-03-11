defmodule GrantlandWeb.PoolLive.Show do
  use GrantlandWeb, :live_view

  alias Grantland.Data
  alias Grantland.Engine

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    pool = Engine.get_pool!(id)

    games_for_next_round =
      Engine.get_active_round_in_pool(pool.id)
      |> Engine.games_matched_to_round()
      |> Enum.map(fn game -> Data.game_for_view(game) end)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:pool, pool)
     |> assign(:games_for_next_round, games_for_next_round)}
  end

  defp page_title(:show), do: "Show Pool"
  defp page_title(:edit), do: "Edit Pool"
end

defmodule GrantlandWeb.GameLive.Index do
  use GrantlandWeb, :live_view

  alias Grantland.Infra
  alias Grantland.Infra.{College, Game}

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Infra.subscribe()

    teams = Enum.map(College.teams(), fn {_key, value} -> value end)
    socket = assign(socket, teams: teams)

    {:ok, assign(socket, :games, list_games_for_view()), temporary_assigns: [games: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Game")
    |> assign(:game, Infra.get_game!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Game")
    |> assign(:game, %Game{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Games")
    |> assign(:game, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    game = Infra.get_game!(id)

    case Infra.delete_game(game) do
      {:ok, _user} ->
        teams = Enum.map(College.teams(), fn {_key, value} -> value end)
        socket = assign(socket, teams: teams)

        {
          :noreply,
          assign(socket, :games, list_games_for_view())
          |> put_flash(:info, "Game deleted successfully")
        }

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_info({:game_created, game}, socket) do
    {:noreply, update(socket, :games, fn games -> [game_for_view(game) | games] end)}
  end

  def handle_info({:game_deleted, game}, socket) do
    {:noreply, update(socket, :games, fn games -> [game_for_view(game) | games] end)}
  end

  @impl true
  def handle_info({:game_updated, game}, socket) do
    {:noreply, update(socket, :games, fn games -> [game_for_view(game) | games] end)}
  end

  defp game_for_view(game) do
    Infra.game_for_view(game)
  end

  defp list_games_for_view do
    Infra.list_games_for_view()
  end
end

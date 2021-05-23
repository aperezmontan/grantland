defmodule GrantlandWeb.PoolLive.FormComponent do
  use GrantlandWeb, :live_component

  alias Grantland.Data
  alias Grantland.Engine

  @impl true
  def mount(socket) do
    pool_types = Engine.list_pool_types()

    games =
      Data.list_games_with_team_name() |> Enum.map(&{"#{&1.away_team} at #{&1.home_team}", &1.id})

    socket = assign(socket, pool_types: pool_types, games: games, number_of_rounds: 1)

    {:ok, socket}
  end

  @impl true
  def update(%{pool: pool} = assigns, socket) do
    selected_games =
      case is_nil(pool.id) do
        true ->
          []

        false ->
          Engine.get_active_round_in_pool(pool.id)
          |> Engine.games_matched_to_round()
          |> Enum.map(fn game -> game.id end)
      end

    changeset = Engine.change_pool(pool)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:selected_games, selected_games)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("dec_round_number", _params, socket) do
    {:noreply, update(socket, :number_of_rounds, &(&1 - 1))}
  end

  @impl true
  def handle_event("inc_round_number", _params, socket) do
    {:noreply, update(socket, :number_of_rounds, &(&1 + 1))}
  end

  @impl true
  def handle_event("validate", %{"pool" => pool_params}, socket) do
    # IO.inspect(pool_params, label: "THE pool_params")

    changeset =
      socket.assigns.pool
      |> Engine.change_pool(pool_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket |> assign(selected_games: pool_params["games"]) |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"pool" => pool_params}, socket) do
    save_pool(socket, socket.assigns.action, pool_params)
  end

  defp save_pool(socket, :edit, pool_params) do
    current_user = socket.assigns.current_user
    pool_params = Map.put(pool_params, "user_id", current_user.id)

    game_ids =
      (pool_params["games"] || [])
      |> Enum.map(fn game_id ->
        {int_game_id, ""} = Integer.parse(game_id)
        int_game_id
      end)

    case Engine.update_pool(socket.assigns.pool, pool_params) do
      {:ok, pool} ->
        Engine.get_active_round_in_pool(pool.id)
        |> Engine.delete_round_games_not_in_this_set(game_ids)
        |> Engine.upsert_round_games(game_ids)

        {:noreply,
         socket
         |> put_flash(:info, "Pool updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_pool(socket, :new, pool_params) do
    IO.inspect(pool_params, label: "ATTEMPTING TO SAVE")
    current_user = socket.assigns.current_user
    pool_params = Map.put(pool_params, "user_id", current_user.id)

    case Engine.activate_pool(pool_params) do
      {:ok, _pool} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pool created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset, label: "THE ERRORS")
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

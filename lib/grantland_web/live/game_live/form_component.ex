defmodule GrantlandWeb.GameLive.FormComponent do
  use GrantlandWeb, :live_component

  alias Grantland.Infra
  alias Grantland.Infra.{College, Game}

  @impl true
  def mount(socket) do
    teams = Enum.map(College.teams(), fn {_key, value} -> value end)
    statuses = Enum.map(Ecto.Enum.values(Game, :status), &{Phoenix.Naming.humanize(&1), &1})

    socket = assign(socket, teams: teams) |> assign(statuses: statuses)

    {:ok, socket}
  end

  @impl true
  def update(%{game: game} = assigns, socket) do
    changeset = Infra.change_game(game)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"game" => game_params}, socket) do
    changeset =
      socket.assigns.game
      |> Infra.change_game(game_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"game" => game_params}, socket) do
    save_game(socket, socket.assigns.action, game_params)
  end

  defp save_game(socket, :edit, game_params) do
    case Infra.update_game(socket.assigns.game, game_params) do
      {:ok, _game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Game updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_game(socket, :new, game_params) do
    case Infra.create_game(game_params) do
      {:ok, _game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Game created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

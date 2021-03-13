defmodule GrantlandWeb.EntryLive.FormComponent do
  use GrantlandWeb, :live_component

  alias Grantland.{Data, Engine}

  @impl true
  def mount(socket) do
    pools = Engine.list_pools()
    socket = assign(socket, pools: pools)
    {:ok, socket}
  end

  @impl true
  def update(%{entry: entry} = assigns, socket) do
    changeset = Engine.change_entry(entry)

    options_for_round =
      case Ecto.assoc_loaded?(entry.picks) && entry.picks do
        false ->
          []

        [] ->
          []

        picks ->
          Enum.map(picks, fn pick ->
            Engine.get_active_round_in_pool(entry.pool.id)
            |> Engine.games_matched_to_round(Grantland.Data.Game, pick.selection[:key])
            |> Data.parse_teams_in_games()
            |> Enum.flat_map(fn game -> game end)
          end)
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:options_for_round, options_for_round)}
  end

  @impl true
  def handle_event("validate", %{"entry" => entry_params}, socket) do
    changeset =
      socket.assigns.entry
      |> Engine.change_entry(entry_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"entry" => entry_params}, socket) do
    save_entry(socket, socket.assigns.action, entry_params)
  end

  defp save_entry(socket, :edit, entry_params) do
    current_user = socket.assigns.current_user
    entry_params = Map.put(entry_params, "user_id", current_user.id)

    case Engine.update_entry(socket.assigns.entry, entry_params) do
      {:ok, _entry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Entry updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_entry(socket, :new, entry_params) do
    current_user = socket.assigns.current_user
    entry_params = Map.put(entry_params, "user_id", current_user.id)

    case Engine.create_entry(entry_params) do
      {:ok, _entry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Entry created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

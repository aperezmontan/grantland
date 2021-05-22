defmodule GrantlandWeb.PoolLive.Show do
  use GrantlandWeb, :live_view

  alias Grantland.Data
  alias Grantland.Engine
  alias Grantland.Engine.Entry

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)}
  end

  # @impl true
  # def handle_params(foo, bar, baz) do
  #   IO.inspect(foo, label: "foo")
  #   IO.inspect(bar, label: "bar")
  #   IO.inspect(baz, label: "baz")
  # end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    {:noreply,
     socket
     |> assign(:pool, Engine.get_pool_with_entries!(id))
     |> assign(:games_for_next_round, games_for_next_round(id))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit Pool")
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Show Pool")
  end

  defp apply_action(socket, :edit_entry, %{"entry_id" => entry_id}) do
    socket
    |> assign(:page_title, "Edit Entry")
    |> assign(:entry, Engine.get_entry!(entry_id))
  end

  defp apply_action(socket, :new_entry, _params) do
    pool = socket.assigns.pool

    socket
    |> assign(:page_title, "Enter #{pool.name}")
    |> assign(:entry, %Entry{pool_id: pool.id})
  end

  # TODO: MOVE THIS TO ENGINE
  defp games_for_next_round(pool_id) do
    Engine.get_active_round_in_pool(pool_id)
    |> Engine.games_matched_to_round()
    |> Enum.map(fn game -> Data.game_for_view(game) end)
  end
end

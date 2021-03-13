defmodule GrantlandWeb.EntryLive.Show do
  use GrantlandWeb, :live_view

  alias Grantland.Engine

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    entry = Engine.get_entry!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:entry, entry)}
  end

  defp page_title(:show), do: "Show Entry"
  defp page_title(:edit), do: "Edit Entry"
end

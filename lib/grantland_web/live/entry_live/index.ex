defmodule GrantlandWeb.EntryLive.Index do
  use GrantlandWeb, :live_view

  alias Grantland.Engine
  alias Grantland.Engine.Entry

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Engine.subscribe()
    socket = assign_defaults(session, socket)
    {:ok, assign(socket, :entries, list_entries()), temporary_assigns: [entries: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Entry")
    |> assign(:entry, Engine.get_entry!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Entry")
    |> assign(:entry, %Entry{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Entries")
    |> assign(:entry, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    entry = Engine.get_entry!(id)

    case Engine.delete_entry(entry) do
      {:ok, _user} ->
        {
          :noreply,
          assign(socket, :entries, list_entries())
          |> put_flash(:info, "Entry deleted successfully")
        }

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_info({:entry_created, entry}, socket) do
    {:noreply, update(socket, :entries, fn entries -> [entry | entries] end)}
  end

  def handle_info({:entry_deleted, entry}, socket) do
    {:noreply, update(socket, :entries, fn entries -> [entry | entries] end)}
  end

  @impl true
  def handle_info({:entry_updated, entry}, socket) do
    {:noreply, update(socket, :entries, fn entries -> [entry | entries] end)}
  end

  defp list_entries do
    Engine.list_entries()
  end
end

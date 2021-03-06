defmodule GrantlandWeb.UserLive.Index do
  use GrantlandWeb, :live_view

  alias Grantland.Identity
  alias Grantland.Identity.User

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Identity.subscribe()
    {:ok, assign(socket, :users, list_users()), temporary_assigns: [users: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, Identity.get_user!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users")
    |> assign(:user, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Identity.get_user!(id)

    case Identity.delete_user(user) do
      {:ok, _user} ->
        {
          :noreply,
          assign(socket, :users, list_users())
          |> put_flash(:info, "User deleted successfully")
        }

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_info({:user_created, user}, socket) do
    {:noreply, update(socket, :users, fn users -> [user | users] end)}
  end

  def handle_info({:user_deleted, user}, socket) do
    {:noreply, update(socket, :users, fn users -> [user | users] end)}
  end

  @impl true
  def handle_info({:user_updated, user}, socket) do
    {:noreply, update(socket, :users, fn users -> [user | users] end)}
  end

  defp list_users do
    Identity.list_users()
  end
end

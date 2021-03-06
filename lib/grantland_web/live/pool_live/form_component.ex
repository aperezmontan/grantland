defmodule GrantlandWeb.PoolLive.FormComponent do
  use GrantlandWeb, :live_component

  alias Grantland.Engine

  @impl true
  def update(%{pool: pool} = assigns, socket) do
    changeset = Engine.change_pool(pool)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"pool" => pool_params}, socket) do
    changeset =
      socket.assigns.pool
      |> Engine.change_pool(pool_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"pool" => pool_params}, socket) do
    save_pool(socket, socket.assigns.action, pool_params)
  end

  defp save_pool(socket, :edit, pool_params) do
    current_user = socket.assigns.current_user
    pool_params = Map.put(pool_params, "user_id", current_user.id)

    case Engine.update_pool(socket.assigns.pool, pool_params) do
      {:ok, _pool} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pool updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_pool(socket, :new, pool_params) do
    current_user = socket.assigns.current_user
    pool_params = Map.put(pool_params, "user_id", current_user.id)

    case Engine.create_pool(pool_params) do
      {:ok, _pool} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pool created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

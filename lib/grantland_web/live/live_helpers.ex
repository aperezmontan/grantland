defmodule GrantlandWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Grantland.Identity
  alias Grantland.Identity.User

  @doc """
  Renders a component inside the `GrantlandWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, GrantlandWeb.PoolLive.FormComponent,
        id: @pool.id || :new,
        action: @live_action,
        pool: @pool,
        return_to: Routes.pool_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)

    modal_opts = [
      id: :modal,
      return_to: path,
      component: component,
      opts: opts
    ]

    live_component(socket, GrantlandWeb.ModalComponent, modal_opts)
  end

  def assign_defaults(session, socket) do
    assign_new(socket, :current_user, fn ->
      find_current_user(session)
    end)
  end

  def can_edit(resource, user) when not is_nil(user) do
    user.role == :admin || user.id == resource.user_id
  end

  def can_edit(_resource, _user) do
    false
  end

  defp find_current_user(session) do
    with user_token when not is_nil(user_token) <- session["user_token"],
         %User{} = user <- Identity.get_user_by_session_token(user_token),
         do: user
  end

  def users_path?([]) do
    false
  end

  def users_path?([first_element | _]) do
    first_element == "users"
  end
end

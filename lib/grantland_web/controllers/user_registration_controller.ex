defmodule GrantlandWeb.UserRegistrationController do
  use GrantlandWeb, :controller

  alias Grantland.Identity
  alias Grantland.Identity.User
  alias GrantlandWeb.UserAuth

  def new(conn, _params) do
    changeset = Identity.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Identity.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Identity.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
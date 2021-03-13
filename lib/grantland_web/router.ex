defmodule GrantlandWeb.Router do
  use GrantlandWeb, :router

  import GrantlandWeb.UserAuth

  alias GrantlandWeb.EnsureRolePlug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    # plug :fetch_live_flash
    plug :put_root_layout, {GrantlandWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :guest do
    plug EnsureRolePlug, [:admin, :moderator, :user, :guest]
  end

  pipeline :user do
    plug EnsureRolePlug, [:admin, :moderator, :user]
  end

  pipeline :moderator do
    plug EnsureRolePlug, [:admin, :moderator]
  end

  pipeline :admin do
    plug EnsureRolePlug, :admin
  end

  ## Authentication routes

  scope "/", GrantlandWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  ## Authorization routes

  # TEST ROUTES
  scope "/", GrantlandWeb do
    pipe_through [:browser, :require_authenticated_user, :user]
    live "/user_dashboard", UserDashboardLive, :index
  end

  scope "/", GrantlandWeb do
    pipe_through [:browser, :require_authenticated_user, :admin]
    live "/admin_dashboard", AdminDashboardLive, :index
  end

  # REAL ROUTES

  # requires admin
  scope "/", GrantlandWeb do
    pipe_through [:browser, :require_authenticated_user, :admin]

    # Games
    live "/games", GameLive.Index, :index
    live "/games/new", GameLive.Index, :new
    live "/games/:id/edit", GameLive.Index, :edit

    live "/games/:id", GameLive.Show, :show
    # TOOD: Figure out what route this is?
    live "/games/:id/show/edit", GameLive.Show, :edit
  end

  scope "/", GrantlandWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live "/pools/:id/show/entries/:id/show/edit", PoolLive.Show, :edit
    live "/pools/:id/show/entries/new", PoolLive.Show, :new

    # Entries
    live "/entries/new", EntryLive.Index, :new
    live "/entries/:id/edit", EntryLive.Index, :edit
    # TOOD: Figure out what route this is?
    live "/entries/:id/show/edit", EntryLive.Show, :edit

    # Pools
    live "/pools/new", PoolLive.Index, :new
    live "/pools/:id/edit", PoolLive.Index, :edit
    # TOOD: Figure out what route this is?
    live "/pools/:id/show/edit", PoolLive.Show, :edit

    # Users
    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id/edit", UserLive.Index, :edit

    live "/users/:id", UserLive.Show, :show
    # TOOD: Figure out what route this is?
    live "/users/:id/show/edit", UserLive.Show, :edit

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  # Routes open to all

  scope "/", GrantlandWeb do
    pipe_through :browser

    live "/", PageLive, :index

    # Entries
    live "/entries", EntryLive.Index, :index
    live "/entries/:id", EntryLive.Show, :show

    # Pools
    live "/pools", PoolLive.Index, :index
    live "/pools/:id", PoolLive.Show, :show

    # FOR SOME LAYOUT TESTING
    live "/layout", LayoutLive, :index
    live "/new_layout", NewLayoutLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", GrantlandWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: GrantlandWeb.Telemetry
    end
  end
end

defmodule Grantland.Repo do
  use Ecto.Repo,
    otp_app: :grantland,
    adapter: Ecto.Adapters.Postgres
end

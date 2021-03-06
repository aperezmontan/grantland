# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Grantland.Repo.insert!(%Grantland.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Grantland.Identity.register_admin(%{
  email: "admin@company.com",
  password: "123456789abc",
  password_confirmation: "123456789abc"
})

Grantland.Identity.register_user(%{
  email: "moderator@company.com",
  password: "123456789abc",
  password_confirmation: "123456789abc",
  role: :moderator
})

Grantland.Identity.register_user(%{
  email: "user@company.com",
  password: "123456789abc",
  password_confirmation: "123456789abc",
  role: :user
})

Grantland.Identity.register_user(%{
  email: "guest@company.com",
  password: "123456789abc",
  password_confirmation: "123456789abc",
  role: :guest
})

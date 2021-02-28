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

alias Grantland.Accounts

roles = [
  %{name: "Admin"},
  %{name: "Moderator"},
  %{name: "User"},
  %{name: "Guest"}
]

Enum.each(roles, fn role ->
  Accounts.create_role(role)
end)

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

require Ecto.Query

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

admin_user =
  Grantland.Identity.User
  |> Ecto.Query.where([i], i.role == :admin)
  |> Ecto.Query.first()
  |> Grantland.Repo.one()

moderator_user =
  Grantland.Identity.User
  |> Ecto.Query.where([i], i.role == :moderator)
  |> Ecto.Query.first()
  |> Grantland.Repo.one()

guest_user =
  Grantland.Identity.User
  |> Ecto.Query.where([i], i.role == :guest)
  |> Ecto.Query.first()
  |> Grantland.Repo.one()

user_user =
  Grantland.Identity.User
  |> Ecto.Query.where([i], i.role == :user)
  |> Ecto.Query.first()
  |> Grantland.Repo.one()

Grantland.Engine.create_pool(%{
  name: "admin_box_pool",
  user_id: admin_user.id,
  ruleset: %Grantland.Engine.Ruleset{pool_type: :box}
})

Grantland.Engine.create_pool(%{
  name: "admin_knockout_pool",
  user_id: admin_user.id,
  ruleset: %Grantland.Engine.Ruleset{pool_type: :knockout}
})

Grantland.Engine.create_pool(%{
  name: "moderator_box_pool",
  user_id: moderator_user.id,
  ruleset: %Grantland.Engine.Ruleset{pool_type: :box}
})

Grantland.Engine.create_pool(%{
  name: "moderator_knockout_pool",
  user_id: moderator_user.id,
  ruleset: %Grantland.Engine.Ruleset{pool_type: :knockout}
})

Grantland.Engine.create_pool(%{
  name: "user_box_pool",
  user_id: user_user.id,
  ruleset: %Grantland.Engine.Ruleset{pool_type: :box}
})

Grantland.Engine.create_pool(%{
  name: "user_knockout_pool",
  user_id: user_user.id,
  ruleset: %Grantland.Engine.Ruleset{pool_type: :knockout}
})

{:ok, time} = DateTime.now("Etc/UTC")

Grantland.Data.create_game(%{away_team: 0, home_team: 1, time: DateTime.to_string(time)})
Grantland.Data.create_game(%{away_team: 2, home_team: 3, time: DateTime.to_string(time)})
Grantland.Data.create_game(%{away_team: 4, home_team: 5, time: DateTime.to_string(time)})
Grantland.Data.create_game(%{away_team: 6, home_team: 7, time: DateTime.to_string(time)})
Grantland.Data.create_game(%{away_team: 8, home_team: 9, time: DateTime.to_string(time)})

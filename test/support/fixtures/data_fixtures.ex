defmodule Grantland.DataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Grantland.Data` context.
  """

  alias Grantland.Data

  def game_fixture(attrs \\ %{}) do
    {:ok, datetime} = DateTime.now("Etc/UTC")

    {:ok, game} =
      attrs
      |> Enum.into(%{away_team: 0, home_team: 1, time: datetime})
      |> Data.create_game()

    game
  end
end

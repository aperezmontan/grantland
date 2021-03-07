defmodule Grantland.DataTest do
  use Grantland.DataCase

  import Grantland.DataFixtures

  alias Grantland.Data
  alias Grantland.Data.Game

  describe "games" do
    @valid_attrs %{
      away_score: 42,
      away_team: 0,
      home_score: 42,
      home_team: 1,
      status: :scheduled
    }

    @update_attrs %{
      away_score: 43,
      away_team: 2,
      home_score: 43,
      home_team: 3,
      status: :scheduled
    }
    @invalid_attrs %{
      away_score: nil,
      away_team: 1,
      home_score: nil,
      home_team: 1,
      status: nil
    }

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Data.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Data.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      {:ok, datetime} = DateTime.now("Etc/UTC")

      assert {:ok, %Game{} = game} =
               @valid_attrs |> Enum.into(%{time: datetime}) |> Data.create_game()

      assert game.away_score == 42
      assert game.away_team == 0
      assert game.home_score == 42
      assert game.home_team == 1
      assert game.status == :scheduled
      assert DateTime.compare(game.time, datetime |> DateTime.truncate(:second)) == :eq
    end

    test "create_game/1 with invalid data returns error changeset" do
      {:ok, datetime} = DateTime.now("Etc/UTC")

      assert {:error, %Ecto.Changeset{}} =
               @invalid_attrs |> Enum.into(%{time: datetime}) |> Data.create_game()
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, %Game{} = game} = Data.update_game(game, @update_attrs)
      assert game.away_score == 43
      assert game.away_team == 2
      assert game.home_score == 43
      assert game.home_team == 3
      assert game.status == :scheduled
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_game(game, @invalid_attrs)
      assert game == Data.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Data.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Data.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Data.change_game(game)
    end
  end
end

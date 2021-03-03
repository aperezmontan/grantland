defmodule Grantland.InfraTest do
  use Grantland.DataCase

  alias Grantland.Infra

  describe "games" do
    alias Grantland.Infra.Game

    @valid_attrs %{
      away_score: 42,
      away_team: "some away_team",
      home_score: 42,
      home_team: "some home_team",
      status: :scheduled
    }
    @update_attrs %{
      away_score: 43,
      away_team: "some updated away_team",
      home_score: 43,
      home_team: "some updated home_team",
      status: :scheduled
    }
    @invalid_attrs %{
      away_score: nil,
      away_team: nil,
      home_score: nil,
      home_team: nil,
      status: nil
    }

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Infra.create_game()

      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Infra.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Infra.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = Infra.create_game(@valid_attrs)
      assert game.away_score == 42
      assert game.away_team == "some away_team"
      assert game.home_score == 42
      assert game.home_team == "some home_team"
      assert game.status == :scheduled
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Infra.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, %Game{} = game} = Infra.update_game(game, @update_attrs)
      assert game.away_score == 43
      assert game.away_team == "some updated away_team"
      assert game.home_score == 43
      assert game.home_team == "some updated home_team"
      assert game.status == :scheduled
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Infra.update_game(game, @invalid_attrs)
      assert game == Infra.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Infra.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Infra.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Infra.change_game(game)
    end
  end
end

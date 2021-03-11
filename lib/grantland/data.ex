defmodule Grantland.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias Grantland.Repo

  alias Grantland.Data.{College, Game, Views}

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%{id: 1, home_team: "Mets, away_team: "Yankees"}, ...]

  """
  def list_games_with_team_name do
    Repo.all(Game) |> format_games_with_team_names
  end

  defp format_games_with_team_names(games) do
    Enum.map(games, fn game ->
      game = game_for_view(game)

      %{
        id: game.id,
        home_team: game.home_team,
        away_team: game.away_team
      }
    end)
  end

  @doc """
  Returns the list of games formatted for the view.

  ## Examples

      iex> list_games_for_view()
      [%Game{}, ...]

  """
  def list_games_for_view do
    Enum.map(Repo.all(Game), fn game -> game_for_view(game) end)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:game_created)
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
    |> broadcast(:game_updated)
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
    |> broadcast(:game_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def college_teams_for_view do
    Enum.map(College.teams(), fn {_key, value} -> value end)
    |> Enum.map(&{&1.short_name, &1.key})
  end

  def game_for_view(game) do
    {:ok, home_team} = College.team(game.home_team)
    {:ok, away_team} = College.team(game.away_team)

    %Views.Game{
      __meta__: game.__meta__,
      id: game.id,
      home_team: home_team.short_name,
      away_team: away_team.short_name,
      home_score: game.home_score,
      away_score: game.away_score,
      status: game.status,
      time: game.time
    }
  end

  def statuses_for_view do
    Enum.map(Ecto.Enum.values(Game, :status), &{Phoenix.Naming.humanize(&1), &1})
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Grantland.PubSub, "data")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, game}, event) do
    Phoenix.PubSub.broadcast(Grantland.PubSub, "data", {event, game})
    {:ok, game}
  end
end

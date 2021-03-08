defmodule Grantland.Data.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :away_score, :integer, default: 0
    field :away_team, :integer
    field :home_score, :integer, default: 0
    field :home_team, :integer

    field :status, Ecto.Enum,
      values: [
        :scheduled,
        :in_progress,
        :complete,
        :canceled,
        :other
      ],
      default: :scheduled

    field :time, :utc_datetime

    many_to_many :rounds, Grantland.Engine.Round,
      join_through: "games_rounds",
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:home_team, :away_team, :home_score, :away_score, :status, :time])
    |> validate_required([:home_team, :away_team, :home_score, :away_score, :status, :time])
    |> validate_number(:away_score, greater_than_or_equal_to: 0)
    |> validate_number(:home_score, greater_than_or_equal_to: 0)
    |> validate_different_teams()
  end

  defp validate_different_teams(changeset) do
    home_team = get_field(changeset, :home_team)
    away_team = get_field(changeset, :away_team)

    with {:is_valid, true} <- {:is_valid, changeset.valid?},
         {:different_teams_validation, true} <-
           {:different_teams_validation, home_team != away_team} do
      changeset
    else
      {:is_valid, false} ->
        changeset

      {:different_teams_validation, false} ->
        add_error(changeset, :away_team, "cannot be the same as home team")
    end
  end
end

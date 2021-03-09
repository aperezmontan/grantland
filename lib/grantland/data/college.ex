defmodule Grantland.Data.College do
  @moduledoc """
  This is the College module. It creates college teams.
  """

  alias __MODULE__
  @enforce_keys [:key, :name, :short_name]
  defstruct [:key, :name, :short_name]

  @doc """
  Returns the team info in the form of a struct.

  ## Examples

      iex> Grantland.Data.College.new(0)
      {:ok, %College{key: 0, name: "Michigan Wolverines", short_name: "UM"}}

      iex> Grantland.Data.College.new("foo")
      {:error, :invalid_key}

      iex> Grantland.Data.College.new(100000)
      {:error, :team_not_found}

  """
  def team(key) do
    case select_team(key) do
      {:ok, team} -> {:ok, team}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Returns the teams in the form of a struct.

  ## Examples

      iex> Grantland.Data.College.teams
      %{
        0 => %College{key: 0, name: "Michigan Wolverines", short_name: "UM"},
        1 => %College{key: 1, name: "North Carolina Tar Heels", short_name: "UNC"}
      }

  """
  def teams do
    %{
      0 => %College{
        key: 0,
        name: "Michigan Wolverines",
        short_name: "UM"
      },
      1 => %College{
        key: 1,
        name: "North Carolina Tar Heels",
        short_name: "UNC"
      },
      2 => %College{
        key: 2,
        name: "Ohio State Buckeyes",
        short_name: "OSU"
      },
      3 => %College{
        key: 3,
        name: "Michigan State Spartans",
        short_name: "MSU"
      },
      4 => %College{
        key: 4,
        name: "Iowa Hawkeyes",
        short_name: "IOWA"
      },
      5 => %College{
        key: 5,
        name: "Illinois Fighting Illini",
        short_name: "ILL"
      },
      6 => %College{
        key: 6,
        name: "Notre Dame Fighting Irish",
        short_name: "ND"
      },
      7 => %College{
        key: 7,
        name: "Miami Hurricanes",
        short_name: "UMiami"
      },
      8 => %College{
        key: 8,
        name: "USC Trojans",
        short_name: "USC"
      },
      9 => %College{
        key: 9,
        name: "UCLA Bruins",
        short_name: "UCLA"
      }
    }
  end

  defp select_team(key) when is_integer(key) do
    case teams()[key] do
      %College{} = team -> {:ok, team}
      nil -> {:error, :team_not_found}
    end
  end

  defp select_team(_key) do
    {:error, :invalid_key}
  end
end

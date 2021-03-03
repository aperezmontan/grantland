defmodule Grantland.Infra.College do
  @moduledoc """
  This is the College module. It creates college teams.
  """

  alias __MODULE__
  @enforce_keys [:key, :name, :short_name]
  defstruct [:key, :name, :short_name]

  @doc """
  Returns the team info in the form of a struct.

  ## Examples

      iex> Grantland.Infra.College.new(0)
      {:ok, %College{key: 0, name: "Michigan Wolverines", short_name: "UM"}}

      iex> Grantland.Infra.College.new("foo")
      {:error, :invalid_key}

      iex> Grantland.Infra.College.new(100000)
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

      iex> Grantland.Infra.College.teams
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

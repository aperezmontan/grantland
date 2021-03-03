defmodule Grantland.Infra.Views.Game do
  @moduledoc """
  This is the Game View module.
  """

  @enforce_keys [
    :id,
    :home_team,
    :away_team,
    :home_score,
    :away_score,
    :status,
    :time
  ]
  defstruct [
    :__meta__,
    :id,
    :home_team,
    :away_team,
    :home_score,
    :away_score,
    :status,
    :time
  ]
end

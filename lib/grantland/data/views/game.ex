defmodule Grantland.Data.Views.Game do
  @moduledoc """
  This is the Game View module.
  """

  # TODO: move this to the view folder in GrantlandWeb
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

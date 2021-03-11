defmodule Grantland.Engine do
  @moduledoc """
  The Engine context.
  """

  import Ecto.Query, warn: false
  alias Grantland.Repo

  alias Grantland.Engine.{Entry, Pick, Pool, Round, Ruleset}

  @doc """
  Returns the list of entries.

  ## Examples

      iex> list_entries()
      [%Entry{}, ...]

  """
  def list_entries do
    Entry
    |> order_by([entry], asc: entry.name)
    |> join(:inner, [entry], pool in assoc(entry, :pool))
    # TODO: Get rid of these preloads if possible
    |> preload([_entry, pool], pool: pool)
    |> Repo.all()
  end

  @doc """
  Gets a single entry.

  Raises `Ecto.NoResultsError` if the Entry does not exist.

  ## Examples

      iex> get_entry!(123)
      %Entry{}

      iex> get_entry!(456)
      ** (Ecto.NoResultsError)

  """
  # TODO: Get rid of these preloads if possible
  def get_entry!(id), do: Repo.get!(Entry, id) |> Repo.preload([:pool])

  @doc """
  Gets a single entry with the picks preloaded.

  Raises `Ecto.NoResultsError` if the Entry does not exist.

  ## Examples

      iex> get_entry!(123)
      %Entry{}

      iex> get_entry!(456)
      ** (Ecto.NoResultsError)

  """
  # TODO: Get rid of these preloads if possible
  def get_entry_with_picks!(id), do: Repo.get!(Entry, id) |> Repo.preload([:pool, :picks])

  @doc """
  Creates a entry.

  ## Examples

      iex> create_entry(%{field: value})
      {:ok, %Entry{}}

      iex> create_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entry(attrs \\ %{}) do
    case %Entry{}
         |> Entry.changeset(attrs)
         |> Repo.insert() do
      # TODO: Get rid of these preloads if possible
      {:ok, entry} -> broadcast({:ok, Repo.preload(entry, :pool)}, :entry_created)
      {:error, changeset} -> broadcast({:error, changeset}, :entry_created)
    end
  end

  @doc """
  Updates a entry.

  ## Examples

      iex> update_entry(entry, %{field: new_value})
      {:ok, %Entry{}}

      iex> update_entry(entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_entry(%Entry{} = entry, attrs) do
    case entry
         |> Entry.changeset(attrs)
         |> Repo.update() do
      # TODO: Get rid of these preloads if possible
      {:ok, entry} -> broadcast({:ok, Repo.preload(entry, :pool)}, :entry_updated)
      {:error, changeset} -> broadcast({:error, changeset}, :entry_updated)
    end
  end

  @doc """
  Deletes a entry.

  ## Examples

      iex> delete_entry(entry)
      {:ok, %Entry{}}

      iex> delete_entry(entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_entry(%Entry{} = entry) do
    Repo.delete(entry)
    |> broadcast(:entry_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entry changes.

  ## Examples

      iex> change_entry(entry)
      %Ecto.Changeset{data: %Entry{}}

  """
  def change_entry(%Entry{} = entry, attrs \\ %{}) do
    Entry.changeset(entry, attrs)
  end

  @doc """
  Returns the list of picks.

  ## Examples

      iex> list_picks()
      [%Pick{}, ...]

  """
  def list_picks do
    Pick
    |> order_by([pick], asc: pick.round_id)
    |> join(:inner, [pick], entry in assoc(pick, :entry))
    |> Repo.all()
  end

  @doc """
  Gets a single pick.

  Raises `Ecto.NoResultsError` if the Pick does not exist.

  ## Examples

      iex> get_pick!(123)
      %Pick{}

      iex> get_pick!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pick!(id), do: Repo.get!(Pick, id)

  @doc """
  Creates a pick.

  ## Examples

      iex> create_pick(%{field: value})
      {:ok, %Pick{}}

      iex> create_pick(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pick(attrs \\ %{}) do
    case %Pick{}
         |> Pick.changeset(attrs)
         |> Repo.insert() do
      {:ok, pick} -> broadcast({:ok, pick}, :pick_created)
      {:error, changeset} -> broadcast({:error, changeset}, :pick_created)
    end
  end

  @doc """
  Updates a pick.

  ## Examples

      iex> update_pick(pick, %{field: new_value})
      {:ok, %Pick{}}

      iex> update_pick(pick, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pick(%Pick{} = pick, attrs) do
    case pick
         |> Pick.changeset(attrs)
         |> Repo.update() do
      {:ok, pick} -> broadcast({:ok, pick}, :pick_updated)
      {:error, changeset} -> broadcast({:error, changeset}, :pick_updated)
    end
  end

  @doc """
  Deletes a pick.

  ## Examples

      iex> delete_pick(pick)
      {:ok, %Pick{}}

      iex> delete_pick(pick)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pick(%Pick{} = pick) do
    Repo.delete(pick)
    |> broadcast(:pick_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pick changes.

  ## Examples

      iex> change_pick(pick)
      %Ecto.Changeset{data: %Pick{}}

  """
  def change_pick(%Pick{} = pick, attrs \\ %{}) do
    Pick.changeset(pick, attrs)
  end

  @doc """
  Returns the list of pools.

  ## Examples

      iex> list_pools()
      [%Pool{}, ...]

  """
  def list_pools do
    Repo.all(Pool)
  end

  @doc """
  Returns the list of pool states.

  ## Examples

      iex> list_pool_states()
      [:initialized, ...]

  """
  def list_pool_states do
    Ruleset.valid_pool_states()
  end

  @doc """
  Returns the list of pool types.

  ## Examples

      iex> list_pool_types()
      [:box, ...]

  """
  def list_pool_types do
    Ruleset.valid_pool_types()
  end

  @doc """
  Gets a single pool.

  Raises `Ecto.NoResultsError` if the Pool does not exist.

  ## Examples

      iex> get_pool!(123)
      %Pool{}

      iex> get_pool!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pool!(id), do: Repo.get!(Pool, id)

  @doc """
  Gets a single pool with its rounds preloaded.

  Raises `Ecto.NoResultsError` if the Pool does not exist.

  ## Examples

      iex> get_pool_with_rounds!(123)
      %Pool{}

      iex> get_pool_with_rounds!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pool_with_rounds!(id), do: Repo.get!(Pool, id) |> Repo.preload(:rounds)

  @doc """
  Creates a pool. This method is private as it should only be used by activate_pool.

  ## Examples

      iex> create_pool(%{field: value})
      {:ok, %Pool{}}

      iex> create_pool(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defp create_pool(attrs \\ %{}) do
    %Pool{}
    |> Pool.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pool.

  ## Examples

      iex> update_pool(pool, %{field: new_value})
      {:ok, %Pool{}}

      iex> update_pool(pool, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pool(%Pool{} = pool, attrs) do
    pool
    |> Pool.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pool.

  ## Examples

      iex> delete_pool(pool)
      {:ok, %Pool{}}

      iex> delete_pool(pool)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pool(%Pool{} = pool) do
    Repo.delete(pool)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pool changes.

  ## Examples

      iex> change_pool(pool)
      %Ecto.Changeset{data: %Pool{}}

  """
  def change_pool(%Pool{} = pool, attrs \\ %{}) do
    Pool.changeset(pool, attrs)
  end

  @doc """
  Creates the first round of a new pool, activating it.

  ## Examples

      iex> activate_pool(123)
      {:ok, %Pool{}}

      iex> activate_pool(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def activate_pool(attrs \\ %{}) do
    case create_pool(attrs) do
      {:ok, %Pool{id: id}} ->
        pool = get_pool_with_rounds!(id) |> create_first_active_round_for_pool
        {:ok, pool}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Returns the list of rounds.

  ## Examples

      iex> list_rounds()
      [%Round{}, ...]

  """
  def list_rounds do
    Repo.all(Round)
  end

  @doc """
  Gets a single round.

  Raises `Ecto.NoResultsError` if the Round does not exist.

  ## Examples

      iex> get_round!(123)
      %Round{}

      iex> get_round!(456)
      ** (Ecto.NoResultsError)

  """
  def get_round!(id), do: Repo.get!(Round, id)

  @doc """
  Gets an active Round in a Pool if one exists.

  Raises `Ecto.NoResultsError` if the Round does not exist.

  ## Examples

      iex> get_active_round_in_pool(123)
      %Round{}

      iex> get_active_round_in_pool(456)
      ** nil

  """
  def get_active_round_in_pool(pool_id),
    do: from(r in Round, where: [pool_id: ^pool_id, active: true]) |> Repo.one()

  @doc """
  Creates a round.

  ## Examples

      iex> create_round(%{field: value})
      {:ok, %Round{}}

      iex> create_round(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_round(attrs \\ %{}) do
    %Round{}
    |> Round.changeset(attrs)
    |> Repo.insert()
  end

  defp create_first_active_round_for_pool(pool) do
    case List.first(pool.rounds) do
      nil ->
        %Round{}
        |> Round.changeset(%{active: true, pool_id: pool.id})
        |> Repo.insert()

        Repo.reload!(pool) |> Repo.preload(:rounds)

      _not_nil ->
        {:error, "Pool already started"}
    end
  end

  @doc """
  Updates a round.

  ## Examples

      iex> update_round(round, %{field: new_value})
      {:ok, %Round{}}

      iex> update_round(round, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_round(%Round{} = round, attrs) do
    round
    |> Round.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a round.

  ## Examples

      iex> delete_round(round)
      {:ok, %Round{}}

      iex> delete_round(round)
      {:error, %Ecto.Changeset{}}

  """
  def delete_round(%Round{} = round) do
    Repo.delete(round)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking round changes.

  ## Examples

      iex> change_round(round)
      %Ecto.Changeset{data: %Round{}}

  """
  def change_round(%Round{} = round, attrs \\ %{}) do
    Round.changeset(round, attrs)
  end

  def delete_round_games_not_in_this_set(round, game_ids) when is_list(game_ids) do
    from(gr in "games_rounds",
      where: gr.round_id == ^round.id and gr.game_id not in ^game_ids
    )
    |> Repo.delete_all()

    round
  end

  @doc """
  Query games available on specific date range.

  * `query` - Initial query to start with.  Only games included in this
    query will be considered.
  * `round` - round to look for in games_rounds
  """

  def games_unmatched_to_round(%Grantland.Engine.Round{id: round_id}, query \\ Grantland.Data.Game) do
    from(game in query,
      left_join: game_round in "games_rounds",
      on: game_round.game_id == game.id and game_round.round_id == ^round_id,
      where: is_nil(game_round.game_id)
    )
    |> Repo.all()
  end

  def games_matched_to_round(%Grantland.Engine.Round{id: round_id}, query \\ Grantland.Data.Game) do
    from(game in query,
      inner_join: game_round in "games_rounds",
      on: game_round.game_id == game.id and game_round.round_id == ^round_id
    )
    |> Repo.all()
  end

  def upsert_round_games(round, game_ids) when is_list(game_ids) do
    games =
      Grantland.Data.Game
      |> where([game], game.id in ^game_ids)
      |> Repo.all()

    with {:ok, _struct} <-
           round
           |> Repo.preload(:games)
           |> Round.changeset_update_games(games)
           |> Repo.update!() do
      {:ok, get_round!(round.id)}
    else
      error ->
        error
    end
  end

  # TODO: look into potentially moving this function to the Pool or Ruleset as validations
  @doc """
  Check's a pool's ruleset.

  ## Examples

      iex> check_pool_ruleset(pool, :action)
      {:ok, %Pool{}}

      iex> check_pool_ruleset(pool, :bad_action)
      {:error, :invalid_action}

  """
  def check_pool_ruleset(%Pool{} = pool, action) do
    case Enum.member?(Ruleset.valid_actions(), action) do
      true -> check_ruleset_and_update(pool, action)
      false -> {:error, :invalid_action}
    end
  end

  defp check_ruleset_and_update(%Pool{ruleset: ruleset} = pool, action) do
    case check(ruleset, action) do
      {:ok, ruleset} -> update_pool(pool, %{ruleset: ruleset})
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Create's a standalone Ruleset.

  ## Examples

      iex> create_ruleset(pool, resource, :action)
      {:ok, %Pool{}}

      iex> create_ruleset(pool, resource, :bad_action)
      {:error, :invalid_action}

  """
  def create_ruleset(attrs \\ %{}) do
    Ruleset.new(attrs)
  end

  def check(%Pool.Grantland.Engine.Ruleset{state: :initialized} = ruleset, :start_pool) do
    {:ok, %Pool.Grantland.Engine.Ruleset{ruleset | state: :in_progress}}
  end

  def check(%Pool.Grantland.Engine.Ruleset{state: :in_progress} = ruleset, :start_pool) do
    {:ok, ruleset}
  end

  def check(%Pool.Grantland.Engine.Ruleset{} = ruleset, :complete_pool) do
    {:ok, %Pool.Grantland.Engine.Ruleset{ruleset | state: :completed}}
  end

  def check(%Pool.Grantland.Engine.Ruleset{state: :initialized} = ruleset, :add_entry),
    do: {:ok, ruleset}

  def check(%Pool.Grantland.Engine.Ruleset{state: :in_progress}, :add_entry),
    do: {:error, "Entry cannot be added. Pool's already started."}

  def check(%Pool.Grantland.Engine.Ruleset{state: :completed}, _action),
    do: {:error, "Pool cannot be updated. It's complete."}

  def subscribe do
    Phoenix.PubSub.subscribe(Grantland.PubSub, "engine")
  end

  defp broadcast({:error, _reason} = error, _event) do
    error
  end

  defp broadcast({:ok, entry}, event) do
    Phoenix.PubSub.broadcast(Grantland.PubSub, "engine", {event, entry})
    {:ok, entry}
  end
end

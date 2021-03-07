defmodule Grantland.Engine do
  @moduledoc """
  The Engine context.
  """

  import Ecto.Query, warn: false
  alias Grantland.Repo

  alias Grantland.Engine.{Entry, Pick, Pool, Round}

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
  def get_entry!(id), do: Repo.get!(Entry, id) |> Repo.preload(:pool)

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
  Creates a pool.

  ## Examples

      iex> create_pool(%{field: value})
      {:ok, %Pool{}}

      iex> create_pool(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pool(attrs \\ %{}) do
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

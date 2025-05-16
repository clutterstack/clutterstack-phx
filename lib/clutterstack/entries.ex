defmodule Clutterstack.Entries do
  @moduledoc """
  The Entries context.
  """

  import Ecto.Query, warn: false
  alias Clutterstack.Repo
  alias Clutterstack.Entries.{Entry, Redirect}

  @doc """
  Returns a skinny list of all the entries of
  a given `kind`.

  ## Examples

      iex> list_by_kind(post)
      [%Entry{}, ...]
  """

  def list_by_kind(kind) do
    query = from(p in Entry,
      where: p.kind == ^kind,
      select: %{path: p.path, title: p.title, kind: p.kind, section: p.section, date: p.date})
    Repo.all(query)
  end

  def list_sections(kind) do
    query = from(p in Entry,
      where: p.kind == ^kind,
      distinct: true,
      select: p.section)
      Repo.all(query)
  end

  def list_by_section(kind, section) do
    query = from(p in Entry,
      where: p.kind == ^kind,
      where: p.section == ^section,
      select: %{path: p.path, title: p.title, kind: p.kind, date: p.date})
    Repo.all(query)
  end

  @doc """
  Returns a list of the num latest *full* entries
  of `kind` "post", by date field.

  ## Examples

      iex> latest_entries(2)
      [%Entry{}, %Entry{}]
  """

  def latest_posts(num) do
    query = from p in Entry,
      where: p.kind == "post",
      order_by: [desc: p.date],
      limit: ^num
    Repo.all(query)
    # Repo.all returns a list of Entry structs but
    # within each one, meta is a json string, and I
    # want it to be a map of k-v pairs.
    |> Enum.map(fn entry ->
      Map.update!(entry, :meta, &Jason.decode!/1)
    end)
  end

  @doc """
  Returns a list of the num latest *full* entries
  by date field.

  ## Examples

      iex> latest_entries(2)
      [%Entry{}, %Entry{}]
  """
  def latest_entries(num) do
    query = from p in Entry,
      order_by: [desc: p.date],
      limit: ^num
    Repo.all(query)
    # Repo.all returns a list of Entry structs but
    # within each one, meta is a json string, and I
    # want it to be a map of k-v pairs.
    |> Enum.map(fn entry ->
      Map.update!(entry, :meta, &Jason.decode!/1)
    end)
  end

  @doc """
  Returns the single entry, if any, with the
  given path value.

  ## Examples

      iex> entry_by_path(path)
      %Entry{}
  """
  def entry_by_path!(path) do
    Repo.get_by!(Entry, path: path)
    |> Map.update!(:meta, &Jason.decode!/1)
  end

  # For validating redirects
  def entry_path_exists?(path) do
    Repo.exists?(from e in "entries", where: e.path == ^path)
  end

  def create_redirect(attrs) do
    new_path = attrs[:new_path] || attrs["new_path"]

    if entry_path_exists?(new_path) do
      %Redirect{}
      |> Redirect.changeset(attrs)
      |> Repo.insert(
        on_conflict: [set: [new_path: new_path]],
        conflict_target: :redirect_from
      )
    else
      {:error, "new_path must reference an existing entry path"}
    end
  end

  def upsert_entry(attrs \\ %{}) do
    # IO.inspect(attrs, label: "trying to upsert! attrs:")
    %Entry{}
    |> Entry.changeset(attrs)
    # |> IO.inspect()
    |> Repo.insert(on_conflict: :replace_all)
  end

  def upsert_redirect(attrs \\ %{}) do
    # IO.inspect(attrs, label: "trying to upsert! attrs:")
    %Redirect{}
    |> Redirect.changeset(attrs)
    # |> IO.inspect(label: "inside upsert_redirect!()")
    |> Repo.insert(on_conflict: :replace_all)
  end

  def read_redirects() do
    query = from r in Redirect,
    select: {r.redirect_from, r.new_path}
    Repo.all(query)
  end

  # Helper to get all redirects for an entry (Claude suggested this;
  # I don't know where to use it yet)
  def redirects_query(entry) do
    from r in Clutterstack.Entries.Redirect,
      where: r.new_path == ^entry.path
  end

  #######################################################
  ########### Stock generated resource functions ########
  #######################################################

  @doc """
  Returns the list of entries.

  ## Examples

      iex> list_entries()
      [%Entry{}, ...]

  """
  def list_entries do
    Repo.all(Entry)
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
  def get_entry!(id), do: Repo.get!(Entry, id)

  @doc """
  Creates a entry.

  ## Examples

      iex> create_entry(%{field: value})
      {:ok, %Entry{}}

      iex> create_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entry(attrs \\ %{}) do
    %Entry{}
    |> Entry.changeset(attrs)
    |> Repo.insert()
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
    entry
    |> Entry.changeset(attrs)
    |> Repo.update()
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
end

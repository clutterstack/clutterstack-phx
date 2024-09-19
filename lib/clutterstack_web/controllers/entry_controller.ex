defmodule ClutterstackWeb.EntryController do
  use ClutterstackWeb, :controller

  alias Clutterstack.Entries
  alias Clutterstack.Entries.Entry

  def home(conn, _params) do
    page = Entries.latest_posts(1) |> List.first()
    render(conn, :home, page: page, page_title: "Home")
  end

  def posts(conn, _params) do
    post_list = Entries.list_by_kind("post") |> Enum.sort_by(&(&1.date), :desc) |> IO.inspect(label: "list by kind: ")
    render(conn, :entry_links, items: post_list, page_title: "Posts")
  end

  def particles(conn, _params) do
    particle_list = Entries.list_by_kind("particle") |> Enum.sort_by(&(&1.date), :desc)
    render(conn, :entry_links, items: particle_list, page_title: "Particles")
  end

  def show_path(conn, %{"section" => section, "page" => page}) do
    IO.inspect(section, label: "section in PostsController.show_path")
    path = Path.join(section, page)
    page = Entries.entry_by_path!(path)
    render(conn, :render, page: page)
  end

  ##### Generated actions for generated CRUD resources #####

  def index(conn, _params) do
    entries = Entries.list_entries()
    render(conn, :index, entries: entries)
  end

  def new(conn, _params) do
    changeset = Entries.change_entry(%Entry{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"entry" => entry_params}) do
    case Entries.create_entry(entry_params) do
      {:ok, entry} ->
        conn
        |> put_flash(:info, "Entry created successfully.")
        |> redirect(to: ~p"/entries/#{entry}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    entry = Entries.get_entry!(id)
    render(conn, :show, entry: entry)
  end

  def edit(conn, %{"id" => id}) do
    entry = Entries.get_entry!(id)
    changeset = Entries.change_entry(entry)
    render(conn, :edit, entry: entry, changeset: changeset)
  end

  def update(conn, %{"id" => id, "entry" => entry_params}) do
    entry = Entries.get_entry!(id)

    case Entries.update_entry(entry, entry_params) do
      {:ok, entry} ->
        conn
        |> put_flash(:info, "Entry updated successfully.")
        |> redirect(to: ~p"/entries/#{entry}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, entry: entry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    entry = Entries.get_entry!(id)
    {:ok, _entry} = Entries.delete_entry(entry)

    conn
    |> put_flash(:info, "Entry deleted successfully.")
    |> redirect(to: ~p"/entries")
  end
end

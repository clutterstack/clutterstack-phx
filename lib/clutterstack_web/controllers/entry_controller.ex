defmodule ClutterstackWeb.EntryController do
  use ClutterstackWeb, :controller
  require Logger
  alias Clutterstack.Entries
  alias Clutterstack.Entries.Entry
  alias ClutterstackWeb.SEO

    def home(conn, _params) do
    latest_all = Entries.latest_entries(99) |> Enum.sort_by(&(&1.date), :desc)
    page = Entries.latest_posts(1) |> List.first()

    case page do
      nil ->
        # Provide all expected fields with default values
        render(conn, :home,
          page: %{
            title: "Welcome",
            body: "No posts yet.",
            date: nil,
            kind: "post"
          },
          page_title: "Home",
          items: latest_all,
          seo_meta_tags: default_seo_meta_tags(conn, "Home")
        )
      page ->
        render(conn, :home,
          page: page,
          page_title: "Home",
          items: latest_all,
          seo_meta_tags: default_seo_meta_tags(conn, "Home")
        )
    end
  end

  def oldhome(conn, _params) do
    latest_all = Entries.latest_entries(5) |> Enum.sort_by(&(&1.date), :desc)
    page = Entries.latest_posts(1) |> List.first()

    case page do
      nil ->
        # Provide all expected fields with default values
        render(conn, :home,
          page: %{
            title: "Welcome",
            body: "No posts yet.",
            date: nil,
            kind: "post"
          },
          page_title: "Home",
          items: latest_all,
          seo_meta_tags: default_seo_meta_tags(conn, "Home")
        )
      page ->
        render(conn, :home,
          page: page,
          page_title: "Home",
          items: latest_all,
          seo_meta_tags: default_seo_meta_tags(conn, "Home")
        )
    end
  end

  def posts(conn, _params) do
    post_list = Entries.list_by_kind("post") |> Enum.sort_by(&(&1.date), :desc) # |> IO.inspect(label: "list by kind: ")
    render(conn, :entry_links,
      items: post_list,
      page_title: "Posts",
      seo_meta_tags: default_seo_meta_tags(conn, "Posts")
    )
  end

  def particles(conn, _params) do
    section_list = Entries.list_sections("particle")
    particle_list = Entries.list_by_kind("particle") |> Enum.sort_by(&(&1.date), :desc)
    render(conn, :particles,
      sections: section_list,
      all_items: particle_list,
      page_title: "Particles",
      seo_meta_tags: default_seo_meta_tags(conn, "Particles")
    )
  end

  def show_particle(conn, %{"theme" => theme, "page" => page_param, "volubility" => volubility_list} = params) do
    Logger.info("in show_particle, volubility_list: " <> to_string(volubility_list))
    volubility = case volubility_list do
      [] -> "voluble"
      [something] -> something # hopefully if it's not "voluble" it's "terse"
    end
    path = Path.join(["particles", theme, page_param])
    key = Map.get(params, "key")

    # Check drafts first if key provided
    page = if key do
      Entries.get_draft_by_path_and_key(path, key)
    else
      nil
    end

    # Fall back to entries if not found in drafts
    page = page || Entries.entry_by_path(path)

    # 404 if not found in either table
    if is_nil(page) do
      conn
      |> put_status(:not_found)
      |> put_view(ClutterstackWeb.ErrorHTML)
      |> render(:"404")
    else
      # Logger.info("page meta: " <> IO.inspect(page.meta["keywords"]))
      has_terse_version =
      if page.meta["versions"] do
        if ("terse" in page.meta["versions"]), do: true, else: false
      else
        false
      end
      Logger.info("has terse version? " <> to_string(has_terse_version))

      # Generate SEO meta tags
      seo_meta_tags = SEO.build_meta_tags(page)
      seo_meta_tags = Map.put(seo_meta_tags, :canonical_url, SEO.canonical_url(page, conn))

      render(conn, :particle,
        page: page,
        page_title: page.title,
        volubility: volubility,
        path: path,
        has_terse_version: has_terse_version,
        seo_meta_tags: seo_meta_tags
      )
    end
  end

  def show_post(conn, %{"page" => page_param, "volubility" => volubility_list} = params) do
    volubility = case volubility_list do
      [] -> "voluble"
      [something] -> something
    end
    path = Path.join("posts", page_param)
    key = Map.get(params, "key")

    # Check drafts first if key provided
    page = if key do
      Entries.get_draft_by_path_and_key(path, key)
    else
      nil
    end

    # Fall back to entries if not found in drafts
    page = page || Entries.entry_by_path(path)

    # 404 if not found in either table
    if is_nil(page) do
      conn
      |> put_status(:not_found)
      |> put_view(ClutterstackWeb.ErrorHTML)
      |> render(:"404")
    else
      has_terse_version =
        if page.meta["versions"] do
          if ("terse" in page.meta["versions"]), do: true, else: false
        else
          false
        end
      Logger.info("has terse version? " <> to_string(has_terse_version))

      # Get adjacent posts for navigation
      {prev_post, next_post} = Entries.get_adjacent_posts(path)

      # Generate SEO meta tags
      seo_meta_tags = SEO.build_meta_tags(page)
      seo_meta_tags = Map.put(seo_meta_tags, :canonical_url, SEO.canonical_url(page, conn))

      render(conn, :post,
        page: page,
        page_title: page.title,
        volubility: volubility,
        path: path,
        has_terse_version: has_terse_version,
        prev_post: prev_post,
        next_post: next_post,
        seo_meta_tags: seo_meta_tags
      )
    end
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

  defp default_seo_meta_tags(conn, title, description \\ nil) do
    canonical_url = SEO.canonical_base_url() <> conn.request_path
    final_description = description || "#{title} - Clutterstack"

    %{
      description: final_description,
      og_title: title,
      og_description: final_description,
      og_type: "website",
      og_tags: [],
      twitter_title: title,
      twitter_description: final_description,
      canonical_url: canonical_url
    }
  end
end

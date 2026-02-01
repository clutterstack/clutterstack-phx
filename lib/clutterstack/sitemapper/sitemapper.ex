defmodule Clutterstack.Sitemapper do
  alias Clutterstack.Repo

  # Using the Sitemapper library https://github.com/breakroom/sitemapper
  # See https://framagit.org/framasoft/mobilizon/-/blob/#0e5d1027c92617b290fd226c7b5af8262f3447af/lib/service/site_map.ex
  # for a very nice sitemapper setup

  @doc false
  # Parse date string (YYYY-MM-DD) to Date struct (internal use, exposed for testing)
  def parse_date(date_string) when is_binary(date_string) do
    case Date.from_iso8601(date_string) do
      {:ok, date} -> date
      {:error, _} -> nil
    end
  end
  def parse_date(_), do: nil

  @doc false
  # Calculate content age in months (internal use, exposed for testing)
  def content_age_in_months(date_string) when is_binary(date_string) do
    case parse_date(date_string) do
      nil -> nil
      date ->
        today = Date.utc_today()
        Date.diff(today, date) / 30 |> trunc()
    end
  end
  def content_age_in_months(_), do: nil

  @doc false
  # Determine changefreq based on content age (internal use, exposed for testing)
  def determine_changefreq(date_string) do
    case content_age_in_months(date_string) do
      nil -> :yearly  # fallback for missing dates
      age when age < 6 -> :monthly
      _ -> :yearly
    end
  end

  @doc false
  # Convert Entry to Sitemapper.URL with all fields (internal use, exposed for testing)
  def entry_to_sitemap_url(%Clutterstack.Entries.Entry{path: path, date: date}) do
    %Sitemapper.URL{
      loc: "https://clutterstack.com/#{path}",
      lastmod: parse_date(date),
      changefreq: determine_changefreq(date),
      priority: 0.8
    }
  end

  def generate_sitemap() do
    config = [
      store: Sitemapper.FileStore,
      store_config: [
        path: "priv/static/sitemaps/"
        ],
      gzip: false,
      sitemap_url: "https://clutterstack.com"
    ]

    # Define homepage with highest priority
    homepage = %Sitemapper.URL{
      loc: "https://clutterstack.com/",
      lastmod: Date.utc_today(),
      changefreq: :weekly,
      priority: 1.0
    }

    # Define index pages with medium priority
    index_pages = [
      %Sitemapper.URL{
        loc: "https://clutterstack.com/particles",
        lastmod: Date.utc_today(),
        changefreq: :weekly,
        priority: 0.6
      },
      %Sitemapper.URL{
        loc: "https://clutterstack.com/posts",
        lastmod: Date.utc_today(),
        changefreq: :weekly,
        priority: 0.6
      }
    ]

    # Stream entries, convert to URLs, add static URLs, generate sitemap
    Repo.transaction(fn ->
      Clutterstack.Entries.Entry
      |> Repo.stream()
      |> Stream.map(&entry_to_sitemap_url/1)
      |> Stream.concat([homepage | index_pages])
      |> Sitemapper.generate(config)
      |> Sitemapper.persist(config)
      |> Stream.run()
    end)
  end

end

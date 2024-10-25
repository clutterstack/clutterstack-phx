defmodule Clutterstack.Sitemapper do
  alias Clutterstack.Repo

  # See https://framagit.org/framasoft/mobilizon/-/blob/#0e5d1027c92617b290fd226c7b5af8262f3447af/lib/service/site_map.ex
  # for a very nice sitemapper setup

  def generate_sitemap() do
    config = [
      store: Sitemapper.FileStore,
      store_config: [
        path: "priv/static/sitemaps/"
        ],
      gzip: false,
      sitemap_url: "https://clutterstack.com/sitemaps/" # individual sitemap files will be served with Plug.Static from the sitemaps dir
    ]

    static_routes = [
      %Sitemapper.URL{
        loc: "https://clutterstack.com/particles/",
        changefreq: :weekly
      },
      %Sitemapper.URL{
        loc: "https://clutterstack.com/posts/",
        changefreq: :weekly
      }
    ]

    Repo.transaction(fn ->
      # with {:ok, user} <- create_user(user_params)
      Clutterstack.Entries.Entry
      |> Repo.stream()
      |> Stream.map(fn %Clutterstack.Entries.Entry{path: path} ->
        %Sitemapper.URL{
          loc: "https://clutterstack.com/#{path}",
          changefreq: :weekly
        }
      end)
      |> Stream.concat(static_routes)
      |> Sitemapper.generate(config)
      |> Sitemapper.persist(config)
      |> Stream.run()
    end)
  end
end

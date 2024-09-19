defmodule Clutterstack do
  @moduledoc """
  Clutterstack keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Clutterstack.Entries

  # An app function to populate my content from markdown and other source files using my Nimble Publisher module:

  def build_pages() do
    entries = Cansite.Publish.all_entries()

    for entry <- entries do
      store_doc(entry)
    end

    #copy files from markdown/images/ to /priv/static/images/
    # Path.wildcard/2 and File.cp!/3
    asset_files = Path.wildcard("./markdown/**/*.{svg,webp,jpg,png}")
    IO.inspect(asset_files, label: "files found:")
    for filepath <- asset_files do
      # IO.inspect(filepath, label: "filepath")
      relpath = Path.relative_to(filepath, "markdown/") #|> IO.inspect(label: "relative_to")
      newpath = Path.join(["priv/static/images/", relpath]) #|> IO.inspect(label: "newpath")
      File.mkdir_p(Path.dirname(newpath))
      File.cp!(filepath, newpath, on_conflict: fn _src, _dest -> true end)
    end
    :ok
  end

  def store_doc(entry) do
    entrymap = Map.from_struct(entry)
    meta_JSON = Jason.encode!(entrymap.meta)
    newmap = entrymap |> Map.replace(:meta, meta_JSON)
    Entries.upsert_entry!(newmap)
  end

  # These templates aren't used when populating the database
  # Keeping them in case I want to output html files at some
  # point
  # def entry(assigns) do
  #   ~H"""
  #   <.layout>
  #   <%= raw @entry.body %>
  #   </.layout>
  #   """
  # end

  # def layout(assigns) do
  #   ~H"""
  #   <html>
  #   <head>
  #     <link rel="stylesheet" href="/assets/app.css" />
  #     <script type="text/javascript" src="/assets/app.js" />
  #   </head>
  #   <body>
  #     <%=render_slot(@inner_block) %>
  #   </body>
  #   </html>
  #   """
  # end

end

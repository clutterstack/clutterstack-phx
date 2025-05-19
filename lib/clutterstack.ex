defmodule Clutterstack do
  @moduledoc """
  Clutterstack keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Clutterstack.Entries
  require Logger

  # An app function to populate my content from markdown and other source files using my Nimble Publisher module:

  def build_pages() do
    entries = Clutterstack.Publish.all_entries()

    for entry <- entries do
      store_doc(entry)
    end

    #copy files from markdown/images/ to /priv/static/images/
    # Path.wildcard/2 and File.cp!/3
    asset_files = Path.wildcard("./markdown/**/*.{svg,webp,jpg,png}") || ""
    # IO.inspect(asset_files, label: "files found")
    Logger.info("Asset files found: #{inspect asset_files}")
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
    entry_map = Map.from_struct(entry)
    Logger.debug("entry_map[meta][\"redirect_from\"]: #{inspect entry_map[:meta]["redirect_from"]}")

    # Extract redirect_from and path before JSON encoding
    redirects = get_in(entry_map, [:meta, "redirect_from"])
    Logger.debug("checking on value of redirect_from before cond: #{inspect redirects}")
    new_meta = cond do
      redirects != nil ->
        path = get_in(entry_map, [:path])
        Logger.debug("Found a redirect from #{redirects} to #{path}.")
        # For every old path, store an entry in the redirects table
        for redirect_from <- redirects do
          Entries.upsert_redirect(%{
            redirect_from: redirect_from,
            new_path: path
          })
        end
        # Return meta without redirect_from
        Map.delete(entry_map.meta, "redirect_from")
      redirects == nil ->
        # Return meta unchanged
        entry_map.meta
    end
    json_meta = Jason.encode!(new_meta)
    new_map = entry_map |> Map.replace(:meta, json_meta)
    stored_entry = Entries.upsert_entry(new_map)
    {:ok, stored_entry}
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

defmodule Clutterstack.MarkdownWatcher do
  use GenServer
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
      # Start watching the markdown directory
      {:ok, watcher_pid} = FileSystem.start_link(dirs: ["markdown"])
      FileSystem.subscribe(watcher_pid)
      Logger.info("Markdown watcher started, monitoring markdown/ directory")
      {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid} = state) do
    if String.ends_with?(path, [".md", ".markdown"]) do
      Logger.info("Markdown file changed: #{path} (events: #{inspect(events)})")

      Task.start(fn ->
        try do
          Logger.info("Starting markdown rebuild...")

          # Check if repo is available
          case Ecto.Repo.all_running() do
            [] -> Logger.error("No Ecto repos are running!")
            repos -> Logger.info("Running repos: #{inspect(repos)}")
          end

          # Run build_pages and check the result
          result = Clutterstack.build_pages()
          Logger.info("build_pages result: #{inspect(result)}")

          # Check if any entries were created/updated
          recent_entries = Clutterstack.Entries.latest_entries(1)
          if recent_entries != [] do
            latest = List.first(recent_entries)
            Logger.info("Most recent entry: #{latest.path} updated at #{latest.updated_at}")
          else
            Logger.warning("No entries found in database after rebuild")
          end

          Clutterstack.Atomfeed.generate_atom_feed()
          Clutterstack.Sitemapper.generate_sitemap()
          Logger.info("Markdown rebuild completed successfully")

          # if Code.ensure_loaded?(Phoenix.LiveReloader) do
          #   Phoenix.LiveReloader.trigger_event(:live_reload, %{
          #     asset_type: :eex,
          #     path: path
          #   })
          # end
        rescue
          e ->
            Logger.error("Error during markdown rebuild: #{inspect(e)}")
            Logger.error(Exception.format(:error, e, __STACKTRACE__))
        end
      end)
    end

    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    Logger.warning("Markdown filesystem watcher stopped")
    {:noreply, state}
  end

  # Catch-all for other messages
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end

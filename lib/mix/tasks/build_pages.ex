defmodule Mix.Tasks.BuildPages do
  use Mix.Task
  @impl Mix.Task

  import Ecto.Query, warn: false
  Logger.configure(level: :info)
  require Logger

  alias Clutterstack.Repo

  def run(_args) do
    Logger.configure(level: :info)
    :logger.add_handler_filter(:default, :track_changes, {
      fn _log, level, _meta ->
        IO.puts "Logger level changed to: #{level}"
        :ignore
      end, nil})
    Logger.debug("BuildPages.run() called")
    things_started? = [:telemetry, :ecto]
    |> Enum.map(&Application.ensure_all_started/1)
    |> Enum.all?(&(elem(&1, 0) == :ok))

    if things_started? do
      # Logger.info("Ecto started.")
      Logger.info("Logger level inside BuildPages.run: #{:logger.get_config().primary.level}")

      Repo.start_link()

      {micro, :ok} = :timer.tc(fn ->
        Clutterstack.build_pages()
      end)
      Logger.info("Built pages in #{micro / 1000}ms")

      {micro, :ok} = :timer.tc(fn ->
        Clutterstack.Atomfeed.generate_atom_feed()
      end)
      Logger.info("Generated Atom feed in #{micro / 1000}ms")

      {micro, {:ok, :ok}} = :timer.tc(fn ->
        Clutterstack.Sitemapper.generate_sitemap()
      end)
      Logger.info("Generated sitemap in #{micro / 1000}ms")

    else
      Logger.error("Failed to start Ecto.")
    end
  end

  # This whole thing doesn't work unless you have the Ecto repo running. And apparently telemetry?
end

# Referred to https://honesw.com/blog/ins-and-outs-of-elixir-mix-tasks

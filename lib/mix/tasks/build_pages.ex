defmodule Mix.Tasks.BuildPages do
  use Mix.Task
  @impl Mix.Task

  import Ecto.Query, warn: false
  Logger.configure(level: :info)
  require Logger

  alias Clutterstack.Repo

  def run(_args) do
    # Mix.Task.run "app.start"
    Logger.configure(level: :info)
    :logger.add_handler_filter(:default, :track_changes, {
      fn _log, level, _meta ->
        IO.puts "Logger level changed to: #{level}"
        :ignore
      end, nil})
    # Application.put_env(:logger, :level, :info)
    things_started? = [:telemetry, :ecto]
    |> Enum.map(&Application.ensure_all_started/1)
    |> Enum.all?(&(elem(&1, 0) == :ok))

    if things_started? do
      Logger.info("Ecto started.")
      Logger.info("Logger level inside BuildPages.run: #{:logger.get_config().primary.level}")

      Repo.start_link()

      {micro, :ok} = :timer.tc(fn ->
      Clutterstack.build_pages()
    end)

      {micro2, {:ok, :ok}} = :timer.tc(fn ->
        Clutterstack.Sitemapper.generate_sitemap()
      end)
      ms = micro / 1000
      ms2 = micro2 / 1000
      Logger.info("built pages in #{ms}ms")
      Logger.info("generated sitemap in #{ms2}ms")
    else
      Logger.error("Failed to start Ecto.")
    end
  end

  # This whole thing doesn't work unless you have the Ecto repo running. And apparently telemetry?
end

# Referred to https://honesw.com/blog/ins-and-outs-of-elixir-mix-tasks

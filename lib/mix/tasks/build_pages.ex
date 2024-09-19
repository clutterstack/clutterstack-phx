defmodule Mix.Tasks.BuildPages do
  use Mix.Task
  @impl Mix.Task

  import Ecto.Query, warn: false

  require Logger

  alias Clutterstack.Repo

  def run(_args) do

    things_started? = [:telemetry, :ecto]
    |> Enum.map(&Application.ensure_all_started/1)
    |> Enum.all?(&(elem(&1, 0) == :ok))

    if things_started? do
      Logger.info("Ecto started.")

      Repo.start_link()

      {micro, :ok} = :timer.tc(fn ->
      Clutterstack.build_pages()
    end)
      ms = micro / 1000

      Logger.info("BUILT in #{ms}ms")
    else
      Logger.error("Failed to start Ecto.")
    end
  end

  # This whole thing doesn't work unless you have the Ecto repo running. And apparently telemetry?
end

# Referred to https://honesw.com/blog/ins-and-outs-of-elixir-mix-tasks

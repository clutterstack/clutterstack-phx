defmodule Cansite.Publish do
  alias Clutterstack.Publish.Entry
  alias Clutterstack.Publish.Parser
  alias Clutterstack.Publish.Converter

  use NimblePublisher,
    parser: Parser,
    build: Entry,
    from: "./markdown/**/*.md*",
    as: :entries,
    html_converter: Converter,
    highlighters: [:makeup_elixir, :makeup_erlang]

  # Let other modules access @entries
  def all_entries, do: @entries
end

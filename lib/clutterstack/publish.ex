defmodule Clutterstack.Publish do
  alias Clutterstack.Publish.Entry
  alias Clutterstack.Publish.Parser
  alias Clutterstack.Publish.Converter

  use NimblePublisher,
    parser: Parser,
    build: Entry,
    from: "./markdown/**/*.md*",
    as: :entries,
    html_converter: Converter,
    highlighters: [:makeup_elixir, :makeup_erlang, :makeup_eex]
    # earmark_options: %Earmark.Options{code_class_prefix: "language-"}

  # Let other modules access @entries
  def all_entries do
    # IO.inspect(:logger.get_config().primary.level, label: "Inside Clutterstack.Publish, the logger level is set to ")
    @entries
  end
end

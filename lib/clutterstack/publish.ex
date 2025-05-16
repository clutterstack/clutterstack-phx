defmodule Clutterstack.Publish do
  alias Clutterstack.Publish.Entry
  alias Clutterstack.Publish.Parser
  alias Clutterstack.Publish.Converter

   require Logger

  # Your configuration
  @parser Parser
  @builder Entry
  @from "./markdown/**/*.md*"
  @html_converter Converter
  @highlighters [:makeup_elixir, :makeup_erlang, :makeup_eex]

  def all_entries do
    # Find all markdown files
    paths = Path.wildcard(@from)

    # Process each file
    entries =
      paths
      |> Enum.map(&process_file/1)
      |> Enum.reject(&match?({:error, _}, &1))
      |> Enum.map(fn {:ok, entry} -> entry end)

    entries
  end

  defp process_file(path) do
    case File.read(path) do
      {:ok, contents} ->
        {attrs, body} = @parser.parse(path, contents)
        html_body = @html_converter.convert(path, body, attrs, highlighters: @highlighters)
        entry = @builder.build(path, attrs, html_body)
        {:ok, entry}

      {:error, reason} ->
        Logger.error("Failed to read #{path}: #{inspect(reason)}")
        {:error, reason}
    end
  end
end

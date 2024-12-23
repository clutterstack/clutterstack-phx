defmodule Clutterstack.Publish.Converter do

  require Logger
  # import Clutterstack.CustomConverters.Sidenotes
  import Clutterstack.CustomConverters.Assorted

  defdelegate highlight(html, options \\ []), to: NimblePublisher.Highlighter

  # Copy some convert functions from Nimble Publisher and go from there
  # https://github.com/dashbitco/nimble_publisher/blob/master/lib/nimble_publisher.ex

  def convert(filepath, body, _attrs, opts) do
    if Path.extname(filepath) in [".md", ".markdown"] do
      Logger.debug("Converting Markdown file")
      # IO.inspect(Path.extname, label: "extname is")
      earmark_opts = Keyword.get(opts, :earmark_options, %Earmark.Options{})
      body_list = splitter(body) # |> IO.inspect(label: "splitter(body)")
      body_out = case body_list do
        [head|tail] -> Enum.map([head|tail], fn item -> convert_item(item, earmark_opts) end)
          # |> IO.inspect(label: "output map?????????")
        one_piece -> convert_item(one_piece, earmark_opts)
        # |> IO.inspect(label: "one_piece")
      end
      # |> IO.inspect(label: "Before join")
      |> Enum.join
      case Keyword.get(opts, :highlighters, []) do
        [] -> body_out
        [_ | _] -> highlight(body_out)
      end
    else # other files we won't change
      Logger.info("#{filepath}: Not a markdown file; passing body through unchanged")
      body
    end
  end

  def splitter(body) do
    helper_comment_pattern = ~r/<!-- (.*?) -->([\s\S]*?)<!-- \/(\1) -->/
    body_list = String.split(body, helper_comment_pattern, include_captures: true)
    # |> IO.inspect(label: "Body split by custom comments")
    body_list
  end

  def convert_item(inputstr, earmark_opts) do
    helper_comment_pattern = ~r/<!-- (.*?) -->([\s\S]*?)<!-- \/(\1) -->/
    case Regex.scan(helper_comment_pattern, inputstr) do
      [[_whole_match, helper, contents, _helper_again]] ->
        # IO.puts("found a helper pattern")
        # IO.puts("helper: #{String.trim(helper)}")
        # IO.puts("contents: #{String.trim(contents)}")
        convert_custom(helper, contents, earmark_opts)
      _ ->
        # IO.inspect(Regex.scan(helper_comment_pattern, inputstr), label: "regex scan result")
        # IO.puts("no helper in this item; processing md to html")
        Earmark.as_html!(inputstr, earmark_opts)
     end
  end
end

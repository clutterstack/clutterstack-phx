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

  # def convert_item(inputstr, earmark_opts) do
  #   helper_comment_pattern = ~r/<!-- (.*?) -->([\s\S]*?)<!-- \/(\1) -->/
  #   case Regex.scan(helper_comment_pattern, inputstr) do
  #     [[_whole_match, helper, contents, _helper_again]] ->
  #       # IO.puts("found a helper pattern")
  #       # IO.puts("helper: #{String.trim(helper)}")
  #       # IO.puts("contents: #{String.trim(contents)}")
  #       convert_custom(helper, contents, earmark_opts)
  #     _ ->
  #       # IO.inspect(Regex.scan(helper_comment_pattern, inputstr), label: "regex scan result")
  #       # IO.puts("no helper in this item; processing md to html")
  #       Earmark.as_html!(inputstr, earmark_opts)
  #    end
  # end


  # Used Claude to adapt this for more flexibility in args, and specifically to take custom classes
  # e.g. <!-- sidenote 3 class="voluble" --> in the Markdown document source
  # right now, the order matters. Have to put other args before classes
  def convert_item(inputstr, earmark_opts) do
    # Simpler pattern that ensures closing tag matches opening tag
    helper_pattern = ~r/<!-- (\w+)(.*?)-->([\s\S]*?)<!-- \/\1 -->/
    # Replace each sidenote while keeping non-matching content intact
  output =
    Regex.replace(helper_pattern, inputstr, fn _whole_match, helper, args_str, contents ->
      {classes, remaining_args} = extract_class_from_args(args_str)

      args = remaining_args
             |> String.split()
             |> Enum.reject(&(&1 == ""))

      convert_custom(helper, contents, earmark_opts, %{
        extra_classes: classes,
        args: args
      })
    end)

  Earmark.as_html!(output, earmark_opts)
end
  # Helper function to extract class from args string
  defp extract_class_from_args(args_str) do
    case Regex.run(~r/class="([^"]*)"/, args_str) do
      [class_str, classes] ->
        # Remove the class="..." from args and return both parts
        remaining = String.replace(args_str, class_str, "")
        {classes, String.trim(remaining)}
      nil ->
        {nil, String.trim(args_str)}
    end
  end
end

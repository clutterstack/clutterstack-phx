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

  # def splitter(body) do
  #   helper_comment_pattern = ~r/<!-- (.*?) -->([\s\S]*?)<!-- \/(\1) -->/
  #   body_list = String.split(body, helper_comment_pattern, include_captures: true)
  #   # |> IO.inspect(label: "Body split by custom comments")
  #   body_list
  # end

  # def splitter(body) do
  #   helper_comment_pattern = ~r/<!-- (.*?) -->([\s\S]*?)<!-- \/\1 -->/
  #   parts = String.split(body, helper_comment_pattern, include_captures: true, trim: true)
  #   # Now parts will contain alternating non-helper and helper content
  #   parts
  # end

  def splitter(body) do
    # Only capture the helper name, not its arguments
    helper_comment_pattern = ~r/<!-- (\w+)[^>]*? -->([\s\S]*?)<!-- \/\1 -->/
    body_list = String.split(body, helper_comment_pattern, include_captures: true)
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

  # Used Claude and ChatGPT to adapt this for more flexibility in args, and specifically to take custom classes
  # e.g. <!-- sidenote 3 class="voluble" --> in the Markdown document source
  # right now, the order matters. Have to put other args before classes
  def convert_item(inputstr, earmark_opts) do
    # Simpler pattern that ensures closing tag matches opening tag
    helper_comment_pattern = ~r/<!-- (\w+)(.*?)-->([\s\S]*?)<!-- \/\1 -->/
    case Regex.scan(helper_comment_pattern, inputstr) do
      [[_whole_match, _helper, _args_str, _contents]] ->
          Regex.replace(helper_comment_pattern, inputstr, fn _whole_match, helper, args_str, contents ->
            Logger.info("in convert_item: helper is #{helper}; args_str is #{args_str}")
            {explicit_classes, remaining_args} = extract_class_from_args(args_str)

            remaining_args_list = remaining_args
              |> String.split()
              |> Enum.reject(&(&1 == ""))
              |> IO.inspect(label: "remaining_args_list")
            Logger.info("in convert_item, sending explicit_classes and remaining_args_list to voluble_arg_to_class as #{explicit_classes} and #{IO.inspect(remaining_args_list)}")
            {classes, args} = voluble_arg_to_class(explicit_classes, remaining_args_list)
          |> IO.inspect()
            convert_custom(helper, contents, earmark_opts, %{
              extra_classes: classes,
              args: args
            })
          end)

      _ ->  Earmark.as_html!(inputstr, earmark_opts)
    end
  end

  # Helper function to extract class from args string
  defp extract_class_from_args(args_str) do
    case Regex.run(~r/class="([^"]*)"/, args_str) do
      [class_str, classes] ->
        Logger.info("in extract_class_from_args: class_str is #{IO.inspect(class_str)}")
        Logger.info("in extract_class_from_args: classes is #{IO.inspect(classes)}")
        # Remove the class="..." from args and return both parts
        remaining_args = String.replace(args_str, class_str, "")
        |> String.trim()
        {classes, remaining_args}
      nil ->
        {nil, String.trim(args_str)}
    end
  end

  defp voluble_arg_to_class(classes, args) do
    Logger.info("voluble_arg_to_class: classes is #{classes}")
    # Move "voluble" from an arg to a class if present
    if "voluble" in args do
      new_args = args |> Enum.reject(&(&1 == "voluble"))
      new_classes = case classes do
        nil -> "voluble"
        _ -> classes <> " voluble"
      end
      {new_classes, new_args}
    else
      {classes, args}
    end
  end

end

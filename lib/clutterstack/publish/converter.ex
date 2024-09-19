defmodule Clutterstack.Publish.Converter do

  require Logger

  # defdelegate highlight(html, options \\ []), to: NimblePublisher.Highlighter

  # Copy some convert functions from Nimble Publisher and add a new one
  # https://github.com/dashbitco/nimble_publisher/blob/master/lib/nimble_publisher.ex

  def convert(filepath, body, _attrs, opts) do
    if Path.extname(filepath) in [".md", ".markdown"] do
    Logger.info("Converting Markdown file")
    # IO.inspect(Path.extname, label: "extname is")
    earmark_opts = Keyword.get(opts, :earmark_options, %Earmark.Options{})
    body_list = splitter(body) |> IO.inspect(label: "splitter(body)")
    body_out = case body_list do
      [head|tail] -> Enum.map([head|tail], fn item -> convert_item(item, earmark_opts) end)
        # |> IO.inspect(label: "output map?????????")
      one_piece -> convert_item(one_piece, earmark_opts)
      # |> IO.inspect(label: "one_piece")
    end
    # |> IO.inspect(label: "Before join")
    |> Enum.join
    body_out
    # case Keyword.get(opts, :highlighters, []) do
      # [] -> html
      # [_ | _] -> highlight(html)
    # end
    else # other files we won't change
      Logger.info("Not a markdown file; passing body through unchanged")
      body
    end
  end

  def splitter(body) do
    helper_comment_pattern = ~r/<!-- (.*?) -->([\s\S]*?)<!-- \/(\1) -->/
    body_list = String.split(body, helper_comment_pattern, include_captures: true)
    |> IO.inspect(label: "Body split by custom comments")
    body_list
  end

  def convert_item(inputstr, earmark_opts) do
    helper_comment_pattern = ~r/<!-- (.*?) -->([\s\S]*?)<!-- \/(\1) -->/
    case Regex.scan(helper_comment_pattern, inputstr) do
      [[_whole_match, helper, contents, _helper_again]] ->
        IO.puts("found a helper pattern")
        # IO.puts("helper: #{String.trim(helper)}")
        # IO.puts("contents: #{String.trim(contents)}")
        convert_custom(helper, contents, earmark_opts)
      _ ->
        IO.inspect(Regex.scan(helper_comment_pattern, inputstr), label: "regex scan result")
        IO.puts("no helper in this item; processing md to html")
        Earmark.as_html!(inputstr, earmark_opts)
     end
  end

  # ======= Processors for the special classes or whatever. ==========
  #
  # Might be better to use some part of Earmark.Restructure on the ast,
  # followed by Earmark.transform/2, but
  # on the other hand, these helper processors are pretty readable.

  def convert_custom("important", contents, earmark_opts) do
    processed_contents = Earmark.as_html!("**Important:** " <> contents, earmark_opts)
    IO.puts("processing helper important")
    # IO.inspect(contents, label: "Contents passed to Earmark")
    # IO.inspect(processed_contents, label: "Earmark processed contents")
    """
    <div class="notice-important">
      #{processed_contents}
    </div>
    """
  end

  def convert_custom("sidenote", contents, earmark_opts) do
    processed_contents = Earmark.as_html!(contents, earmark_opts)
    IO.puts("processing helper sidenote")
    # IO.inspect(contents, label: "Contents passed to Earmark")
    # IO.inspect(processed_contents, label: "Earmark processed contents")
    """
    <aside class="sidenote">
      #{processed_contents}
    </aside>
    """
  end

  def convert_custom("readmore", contents, earmark_opts) do
    processed_contents = Earmark.as_html!(contents, earmark_opts)
    IO.puts("processing helper readmore")
    # IO.inspect(contents, label: "Contents passed to Earmark")
    # IO.inspect(processed_contents, label: "Earmark processed contents")
    """
    <div class="mt-4 text-lg text-violet-600">
      #{processed_contents}
    </div>
    """
  end

  def convert_custom("card", contents, earmark_opts) do
    processed_contents = Earmark.as_html!(contents, earmark_opts)
    IO.puts("processing helper card")
    # IO.inspect(contents, label: "Contents passed to Earmark")
    # IO.inspect(processed_contents, label: "Earmark processed contents")
    """
    <div class="mt-16 bg-violet-100 ">
      #{processed_contents}
    </div>
    """
  end

  def convert_custom(_, contents, _earmark_opts) do
    IO.puts("No known helper found; passing comment through")
    contents
  end

end

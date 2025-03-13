defmodule Clutterstack.CustomConverters.Assorted do
  require Logger
    # ======= Processors for the special classes or whatever. ==========
  #
  # Might be better to use some part of Earmark.Restructure on the ast,
  # followed by Earmark.transform/2, but
  # on the other hand, these helper processors are pretty readable.

  def convert_custom("callout", contents, earmark_opts, opts) do
    IO.puts("processing helper callout")
    processed_contents = Earmark.as_html!(contents, earmark_opts)
    classes = "callout" <> (if opts.extra_classes !== nil, do: " #{opts.extra_classes}", else: "")
    """
    <div class="#{classes}">
      #{processed_contents}
    </div>
    """
  end

  def convert_custom("important", contents, earmark_opts, opts) do
    processed_contents = Earmark.as_html!("**Important:** " <> contents, earmark_opts)
    IO.puts("processing helper important")
    # IO.inspect(contents, label: "Contents passed to Earmark")
    # IO.inspect(processed_contents, label: "Earmark processed contents")
    classes = "notice-important" <> (if opts.extra_classes !== nil, do: " #{opts.extra_classes}", else: "")

    """
    <div class="#{classes}">
      #{processed_contents}
    </div>
    """
  end

  def convert_custom("card", contents, earmark_opts, opts) do
    processed_contents = Earmark.as_html!(contents, earmark_opts)
    IO.puts("processing helper card")
    # IO.inspect(contents, label: "Contents passed to Earmark")
    # IO.inspect(processed_contents, label: "Earmark processed contents")
    classes = "card" <> (if opts.extra_classes !== nil, do: " #{opts.extra_classes}", else: "")
    """
    <div class="#{classes}">
      #{processed_contents}
    </div>
    """
  end

  # A Claude adaptation to add extra classes and use arbitrary numbers to generate a class for the grid row span of the sidenote
  def convert_custom("sidenote", contents, earmark_opts, opts) do
    IO.puts("processing sidenote helper")

    processed_contents = Earmark.as_html!(contents, earmark_opts)
    rows = Enum.find(opts.args, fn x -> is_number(x) or (is_binary(x) and String.match?(x, ~r/^\d+$/)) end) # If there's a number or a string representation of an integer in the args list, take that to be the intended grid-rows span
    base_classes = "sidenote" <> if rows != nil, do: " rowspan-#{rows}", else: ""
    classes = if opts.extra_classes == "", do: base_classes, else: "#{base_classes} #{opts.extra_classes}"

    """
    <aside class="#{classes}">
      #{processed_contents}
    </aside>
    """
  end

  # <!-- details summary="Label" -->
  # Contents to reveal
  # <!-- /details -->
  def convert_custom("details", contents, earmark_opts, opts) do
    IO.puts("processing details helper")
    processed_contents = Earmark.as_html!(contents, earmark_opts)
    summary = Enum.find_value(opts.args, fn x ->
      if is_binary(x) do
        case Regex.run(~r/\bsummary\s?=\s?"(.*)"/, x) do
          [_, capture] -> capture |> IO.inspect(label: "capture")
          nil -> "Details"
        end
      else
        ""
      end
    end)
    processed_summary =  Earmark.as_html!(summary, earmark_opts)
    # Extract content from <p> tags
    |> Floki.find("p") |> Floki.text()
    # IO.inspect(summary, label = "summary")
    classes = if opts.extra_classes == "", do: "", else: "#{opts.extra_classes}"

    """
    <details class="#{classes}">
      <summary>#{processed_summary}</summary>
      #{processed_contents}
    </details>
    """
  end

  # def convert_custom("dl", contents, earmark_opts, _opts) do
  #   IO.puts("processing dl helper")
  #   matchreg = ~r/[^:\n].+?(?:\n:\s+.*)+/
  #   splitreg = ~r/\n(:\s+.*?)/
  #   [item | t] = Regex.scan(matchreg, contents)
  #   IO.inspect(item, label: "item: ")
  #   if item == nil do
  #     Logger.warning("No contents matching definition list pattern.")
  #     ""
  #   end
  #   if t !== [] do
  #     Logger.warning("Too many items found! Helper is limited to one right now.")
  #     ""
  #   else
  #     [item_name | paras] = Regex.split(splitreg, item)
  #           IO.inspect(paras, label: "paras before earmark: ")
  #           processed_name = Earmark.as_html!(item_name, earmark_opts)
  #           processed_paras =
  #             paras
  #               |> Enum.map(fn para -> Earmark.as_html!(para, earmark_opts) end)
  #               |> Enum.map(&{"dd", [], [&1]})
  #               |> IO.inspect(label: "before floki")
  #               |> Floki.raw_html([encode: false, pretty: true])
  #               |> IO.inspect(label: "after floki")

  #           IO.inspect(processed_paras, label: "processed_paras")
  #           # new_string = Enum.join(processed_paras)
  #           # IO.inspect(new_string, label: "new_string")
  #           """
  #           <dl>
  #             <dt>#{processed_name}</dt>
  #             #{processed_paras}
  #           </dl>
  #           """
  #           #new_string
  #   end
  # end

  def convert_custom(_, contents, _earmark_opts, _opts) do
    IO.puts("No known helper found; passing through")
    # Earmark.as_html!(contents, earmark_opts)
    contents
  end

end

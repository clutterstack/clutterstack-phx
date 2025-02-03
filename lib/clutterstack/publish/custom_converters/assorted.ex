defmodule Clutterstack.CustomConverters.Assorted do
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

  def convert_custom("voluble", contents, earmark_opts, opts) do
    processed_contents = Earmark.as_html!(contents, earmark_opts)
    IO.puts("processing voluble helper")
    # IO.inspect(contents, label: "Contents passed to Earmark")
    # IO.inspect(processed_contents, label: "Earmark processed contents")
    classes = "voluble" <> (if opts.extra_classes !== nil, do: " #{opts.extra_classes}", else: "")

    """
    <div class="#{classes}">
      #{processed_contents}
    </div>
    """
  end

  # A Claude adaptation to add extra classes and use arbitrary numbers to generate a class for the grid row span of the sidenote
  def convert_custom("sidenote", contents, earmark_opts, opts) do
    IO.puts("processing helper sidenote")

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

  def convert_custom(_, contents, _earmark_opts, _opts) do
    IO.puts("No known helper found; passing comment through")
    contents
  end

end

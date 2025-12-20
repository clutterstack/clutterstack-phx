if Code.ensure_loaded?(Earmark) do
  defmodule Clutterstack.CustomConverters.Assorted do
  require Logger
    # ======= Processors for the special classes or whatever. ==========
  #
  # Might be better to use some part of Earmark.Restructure on the ast,
  # followed by Earmark.transform/2, but
  # on the other hand, these helper processors are pretty readable.


  @doc """
  A "callout" element with optional title. All args get concatenated into a single string for this purpose:

  ```
  <!-- callout This is my title -->
  Stuff to say
  <!-- /callout -->
  """
  def convert_custom("callout", contents, earmark_opts, opts) do
    IO.puts("processing helper callout")
    title = Enum.join(opts.args, " ")
    processed_contents = Earmark.as_html!("### #{title} #{contents}", earmark_opts)
    classes = "callout" <> (if opts.extra_classes !== nil, do: " #{opts.extra_classes}", else: "")
    """
    <div class="#{classes}">
      #{processed_contents}
    </div>
    """
  end

  def convert_custom("caption", contents, earmark_opts, opts) do
    IO.puts("processing helper caption")
    processed_contents = Earmark.as_html!(contents, earmark_opts)
    classes = "caption" <> (if opts.extra_classes !== nil, do: " #{opts.extra_classes}", else: "")
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

  # Embed a locally hosted video:
  #
  #    <!-- video  path="/images/posts/corro-map-1.webm" title="Corrosion propagation map" -->
  #      World map with grey markers turning green in a random-looking pattern.
  #    <!-- /video -->
  #
  # Text between the tags becomes the accessible description.

  def convert_custom("video", contents, earmark_opts, opts) do
    Logger.info("Processing video helper with opts #{inspect(opts)}")

    {attr_map, positional_args} = parse_video_args(opts.args)
    path = Map.get(attr_map, "path") || List.first(positional_args) || extract_path_from_contents(contents)

    if is_nil(path) or path == "" do
      Logger.warning("Video helper is missing a path argument; skipping render.")
      ""
    else
      title = Map.get(attr_map, "title") || Map.get(attr_map, "aria-label") || build_default_title(path)
      type = Map.get(attr_map, "type", guess_video_type(path))
      preload = Map.get(attr_map, "preload", "metadata")
      width = Map.get(attr_map, "width", "960")
      classes = build_classes("video", opts.extra_classes)

      description_html = build_description_html(contents, earmark_opts)
      {aria_describedby_attr, description_markup} =
        build_description_markup(description_html, Map.get(attr_map, "description-id"), path)

      aria_label_attr = build_attribute("aria-label", title)

      """
      <video class="#{classes}" controls preload="#{preload}" width="#{width}" #{aria_label_attr} #{aria_describedby_attr}>
        <source src="#{path}" type="#{type}">
        Sorry, your browser can’t play this video.
      </video>
      #{description_markup}
      """
    end
  end

  # Claude adapted this to add extra classes and use arbitrary numbers to generate a class for the grid row span of the sidenote
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
  #   Contents to reveal
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
    processed_summary = Earmark.as_html!(summary, earmark_opts)
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

  defp parse_video_args(args) when is_list(args) do
    {attrs, positional} =
      Enum.reduce(args, {%{}, []}, fn raw_arg, {acc_map, positional} ->
        case String.split(raw_arg, "=", parts: 2) do
          [key, value] ->
            cleaned = value |> String.trim() |> String.trim(~s("))
            {Map.put(acc_map, key, cleaned), positional}

          _ ->
            {acc_map, [raw_arg | positional]}
        end
      end)

    {attrs, Enum.reverse(positional)}
  end

  defp parse_video_args(_), do: {%{}, []}

  defp extract_path_from_contents(contents) do
    contents
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.find(fn line -> line != "" end)
  end

  defp build_default_title(path) do
    path
    |> Path.basename()
    |> String.replace("_", " ")
    |> String.replace("-", " ")
  end

  defp guess_video_type(path) do
    case Path.extname(path) do
      ".webm" -> "video/webm"
      ".mp4" -> "video/mp4"
      ".ogg" -> "video/ogg"
      ".mov" -> "video/quicktime"
      _ -> "video/mp4"
    end
  end

  defp build_classes(base, nil), do: base
  defp build_classes(base, ""), do: base
  defp build_classes(base, extra), do: base <> " " <> extra

  defp build_description_html(contents, earmark_opts) do
    contents
    |> String.trim()
    |> case do
      "" -> ""
      trimmed ->
        trimmed
        |> Earmark.as_html!(earmark_opts)
        |> String.trim()
    end
  end

  defp build_description_markup("", _requested_id, _path), do: {"", ""}

  defp build_description_markup(html, requested_id, path) do
    id = requested_id || generate_description_id(path)
    {
      build_attribute("aria-describedby", id),
      """
      <div id="#{id}" class="video-description hidden">
        #{html}
      </div>
      """
    }
  end

  defp generate_description_id(path) do
    slug =
      path
      |> Path.basename()
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9]+/u, "-")
      |> String.trim("-")

    hash = :erlang.phash2(path) |> Integer.to_string(36)

    case slug do
      "" -> "video-description-#{hash}"
      _ -> "video-description-#{slug}-#{hash}"
    end
  end

  defp build_attribute(_name, nil), do: ""
  defp build_attribute(_name, ""), do: ""

  defp build_attribute(name, value) do
    escaped =
      value
      |> to_string()
      |> String.replace("&", "&amp;")
      |> String.replace("\"", "&quot;")
      |> String.replace("'", "&#39;")
      |> String.replace("<", "&lt;")
      |> String.replace(">", "&gt;")

    ~s( #{name}="#{escaped}")
  end

  end
else
  defmodule Clutterstack.CustomConverters.Assorted do
    def convert_custom(_, contents, _earmark_opts, _opts) do
      contents
    end
  end
end

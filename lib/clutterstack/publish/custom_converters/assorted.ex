defmodule Clutterstack.CustomConverters.Assorted do
    # ======= Processors for the special classes or whatever. ==========
  #
  # Might be better to use some part of Earmark.Restructure on the ast,
  # followed by Earmark.transform/2, but
  # on the other hand, these helper processors are pretty readable.

  def convert_custom("callout", contents, earmark_opts) do
    processed_contents = Earmark.as_html!(contents, earmark_opts)
    # IO.puts("processing callout helper ")
    # IO.inspect(contents, label: "Contents passed to Earmark")
    # IO.inspect(processed_contents, label: "Earmark processed contents")
    """
    <div class="callout">
      #{processed_contents}
    </div>
    """
  end
  def convert_custom("important", contents, earmark_opts) do
    processed_contents = Earmark.as_html!("**Important:** " <> contents, earmark_opts)
    # IO.puts("processing helper important")
    # IO.inspect(contents, label: "Contents passed to Earmark")
    # IO.inspect(processed_contents, label: "Earmark processed contents")
    """
    <div class="notice-important">
      #{processed_contents}
    </div>
    """
  end

  def convert_custom("aside", contents, earmark_opts) do
    processed_contents = Earmark.as_html!(contents, earmark_opts)
    IO.puts("processing helper aside")
    # IO.inspect(contents, label: "Contents passed to Earmark")
    # IO.inspect(processed_contents, label: "Earmark processed contents")
    """
    <aside>
      #{processed_contents}
    </aside>
    """
  end

  def convert_custom("readmore", contents, earmark_opts) do
    processed_contents = Earmark.as_html!(contents, earmark_opts)
    IO.puts("processing helper readmore")
    # IO.inspect(contents, label: "Contents passed to `")
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

  defmodule Clutterstack.CustomConverters.Sidenotes do
    # It's a kludge but these custom classes let me tweak how many grid
    # rows a sidenote takes, to match it up with the height of content
    # in the main article


    def convert_custom("sidenote", contents, earmark_opts) do
      processed_contents = Earmark.as_html!(contents, earmark_opts)
      # IO.puts("processing helper sidenote")
      # IO.inspect(contents, label: "Contents passed to Earmark")
      # IO.inspect(processed_contents, label: "Earmark processed contents")
      """
      <aside class="sidenote">
        #{processed_contents}
      </aside>
      """
    end

    def convert_custom("sidenote 1", contents, earmark_opts) do
      processed_contents = Earmark.as_html!(contents, earmark_opts)
      # IO.puts("processing helper sidenote")
      # IO.inspect(contents, label: "Contents passed to Earmark")
      # IO.inspect(processed_contents, label: "Earmark processed contents")
      """
      <aside class="sidenote onerow">
        #{processed_contents}
      </aside>
      """
    end

    def convert_custom("sidenote 2", contents, earmark_opts) do
      processed_contents = Earmark.as_html!(contents, earmark_opts)
      # IO.puts("processing helper sidenote")
      # IO.inspect(contents, label: "Contents passed to Earmark")
      # IO.inspect(processed_contents, label: "Earmark processed contents")
      """
      <aside class="sidenote tworows">
        #{processed_contents}
      </aside>
      """
    end

    def convert_custom("sidenote 3", contents, earmark_opts) do
      processed_contents = Earmark.as_html!(contents, earmark_opts)
      # IO.puts("processing helper sidenote")
      # IO.inspect(contents, label: "Contents passed to Earmark")
      # IO.inspect(processed_contents, label: "Earmark processed contents")
      """
      <aside class="sidenote threerows">
        #{processed_contents}
      </aside>
      """
    end

    def convert_custom("sidenote 4", contents, earmark_opts) do
      processed_contents = Earmark.as_html!(contents, earmark_opts)
      # IO.puts("processing helper sidenote")
      # IO.inspect(contents, label: "Contents passed to Earmark")
      # IO.inspect(processed_contents, label: "Earmark processed contents")
      """
      <aside class="sidenote fourrows">
        #{processed_contents}
      </aside>
      """
    end

    def convert_custom("sidenote 5", contents, earmark_opts) do
      processed_contents = Earmark.as_html!(contents, earmark_opts)
      # IO.puts("processing helper sidenote")
      # IO.inspect(contents, label: "Contents passed to Earmark")
      # IO.inspect(processed_contents, label: "Earmark processed contents")
      """
      <aside class="sidenote fiverows">
        #{processed_contents}
      </aside>
      """
    end
    def convert_custom("sidenote 6", contents, earmark_opts) do
      processed_contents = Earmark.as_html!(contents, earmark_opts)
      # IO.puts("processing helper sidenote")
      # IO.inspect(contents, label: "Contents passed to Earmark")
      # IO.inspect(processed_contents, label: "Earmark processed contents")
      """
      <aside class="sidenote sixrows">
        #{processed_contents}
      </aside>
      """
    end
    def convert_custom("sidenote 7", contents, earmark_opts) do
      processed_contents = Earmark.as_html!(contents, earmark_opts)
      # IO.puts("processing helper sidenote")
      # IO.inspect(contents, label: "Contents passed to Earmark")
      # IO.inspect(processed_contents, label: "Earmark processed contents")
      """
      <aside class="sidenote sevenrows">
        #{processed_contents}
      </aside>
      """
    end


  end

end

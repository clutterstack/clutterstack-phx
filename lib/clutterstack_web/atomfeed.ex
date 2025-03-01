defmodule Clutterstack.Atomfeed do
  # alias Clutterstack.Repo
  alias Clutterstack.Entries
  # Generate an Atom feed for the latest 10 Entries in the db

  def generate_atom_feed() do
    author ={:author, nil, [{:name, nil, "Chris Nicoll"}]}
    uri = "https://clutterstack.com/"
    updated = current_time_iso8601()
    link = {:link, [rel: "alternate", href: uri], nil}
    entries =  Entries.latest_entries(10)
      |> Enum.sort_by(&(&1.date), :desc)
      |> Enum.map(&feedentrytuple(&1.title, &1.path, &1.date, &1.body))

    XmlBuilder.document({:feed, [xmlns: "http://www.w3.org/2005/Atom"], [{:id, nil, uri}, {:updated, nil, updated}, {:title, nil, "Clutterstack"}, {:link, [rel: "self", href: "#{uri}feed.xml"], nil}, author | entries]})
      |> XmlBuilder.generate
      |> write_file()
  end

  defp feedentrytuple(title, path, date, content) do
    uri = "https://clutterstack.com/#{path}/"
    updated = convert_date(date)

    # Remove excess whitespace from HTML content
    trimmed_content = content
    |> String.trim()
    |> String.replace(~r/\s+/, " ")
    {:entry, nil, [
      {:id, nil, uri},
      {:title, nil, title},
      {:updated, nil, updated},
      {:link, [rel: "alternate", href: uri], nil},
      {:content, [type: "html"], {:cdata, trimmed_content}}
    ]}
  end

  defp write_file(rendered) do
    output_dir = "./priv/static/"
    File.mkdir_p!(output_dir)
    outfile = Path.join([output_dir, "feed.xml"])
    File.write!(outfile, rendered)
  end

  defp current_time_iso8601() do
    DateTime.utc_now() |> DateTime.to_iso8601()
  end

  defp convert_date(date_string) do
    # e.g. "2025-02-27"
    {:ok, date} = Date.from_iso8601(date_string)
    datetime = DateTime.new!(date, ~T[00:00:00.000], "Etc/UTC")
    |> DateTime.to_iso8601()
  end
end

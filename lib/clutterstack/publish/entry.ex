defmodule Clutterstack.Publish.Entry do

  @enforce_keys [:title, :path, :body]
  defstruct [:title, :path, :section, :date, :kind, :body, :meta]

  def build(filename, attrs, body) do
    # IO.inspect(attrs, label: "attrs passed to build() in Clutterstack.Publish.Entry")
    path = Path.rootname(filename)
    # IO.puts("path: "<> path)

    section = path |> Path.split() |> Enum.at(-2)
    # IO.puts(section)
    # Get rid of any .md extension
    path = path |> Path.rootname() |> Path.split() |> Enum.drop(1) |> Path.join()
    # IO.inspect(label: "joined truncate path")
    title = attrs["title"]
    kind = Map.get(attrs, "kind")
    date = Map.get(attrs, "date")
    meta = Map.drop(attrs, ["title", "date", "kind"])
    struct!(__MODULE__, [title: title, path: path, section: section, date: date, kind: kind, body: body, meta: meta])
  end
end

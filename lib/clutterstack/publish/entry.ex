defmodule Clutterstack.Publish.Entry do
  require Logger

  @enforce_keys [:title, :path, :body]
  defstruct [:title, :path, :section, :date, :kind, :body, :meta]

  def build(filename, attrs, body) do
    IO.inspect(:logger.get_config().primary.level, label: "Inside Clutterstack.Publish.Entry, the logger level is set to ")
    Logger.debug("Clutterstack.Publish.Entry: #{filename}")
    Logger.debug("attrs passed to build() in Clutterstack.Publish.Entry: #{inspect attrs}")
    path = Path.rootname(filename)
    Logger.debug("path: #{path}")

    # Get rid of any .md extension
    path = path |> Path.rootname() |> Path.split() |> Enum.drop(1) |> Path.join()
    Logger.debug("Joined truncate path: #{path}")
    section = path
      |> Path.split()
      |> Enum.drop(-1)
      |> Enum.at(1) || ""
    Logger.debug("Section in Publish.Entry: #{section}")
    title = attrs["title"]
    kind = Map.get(attrs, "kind")
    date = Map.get(attrs, "date")
    meta = Map.drop(attrs, ["title", "date", "kind"])
    struct!(__MODULE__, [title: title, path: path, section: section, date: date, kind: kind, body: body, meta: meta])
  end
end

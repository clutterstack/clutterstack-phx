defmodule Clutterstack.Publish.Parser do

  def parse(_path, contents) do
    [yaml, body] = String.split(contents, "---\n", parts: 2, trim: true)
    {:ok, attrs} = YamlElixir.read_from_string(yaml)
    {attrs, body}
  end

end

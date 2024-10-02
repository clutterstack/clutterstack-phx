defmodule ClutterstackWeb.EntryHTML do
  use ClutterstackWeb, :html

  embed_templates "entry_html/*"
  if Application.compile_env(:clutterstack, :dev_routes) do
    embed_templates "entry_generated/*"
  end

  @doc """
  Helper to get just the maps with a given section value
  from a list of maps (the all_entries parameter)
  """
  def section_entries(section, all_entries) do
    # IO.inspect(section, label: "section in section_entries/2")
    # IO.inspect(all_entries)
    Enum.filter(all_entries, fn(map) -> Map.get(map, :section) == section end)
  end

end

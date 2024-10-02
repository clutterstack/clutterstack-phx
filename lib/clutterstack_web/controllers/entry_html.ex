defmodule ClutterstackWeb.EntryHTML do
  use ClutterstackWeb, :html

  embed_templates "entry_html/*"
  if Application.compile_env(:clutterstack, :dev_routes) do
    embed_templates "entry_generated/*"
  end

end

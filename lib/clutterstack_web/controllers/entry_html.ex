defmodule ClutterstackWeb.EntryHTML do
  use ClutterstackWeb, :html

  embed_templates "entry_html/*"
  embed_templates "entry_generated/*"


  # Not sure where the following came from. Commenting out.
  # @doc """
  # Renders a entry form.
  # """
  # attr :changeset, Ecto.Changeset, required: true
  # attr :action, :string, required: true

  # def entry_form(assigns)
end

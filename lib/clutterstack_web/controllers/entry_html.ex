defmodule ClutterstackWeb.EntryHTML do
  use ClutterstackWeb, :html
  require Logger

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

  def process_body(markup) do
    {:safe, processed} = markup
    |> Phoenix.HTML.raw()
    |> IO.inspect(label: "processed body")
    processed
  end

  attr :volubility, :string, default: "voluble", doc: "true when checked"
  attr :path, :string
  # attr :rest, :global
  def volubility_switcher(assigns) do
    volubility = assigns.volubility
    Logger.info("switcher log: volubility: " <> volubility)
    ~H"""
    <div id="volubility_switcher" class="flex items-center text-center bg-zinc-200 text-sm flex rounded-lg cursor-pointer">
      <.link class={[@volubility === "terse" && "bg-sky-700 text-white rounded-lg", "p-1"]} href={"/#{@path}/terse"}>Terse</.link>
      <.link class={[@volubility !== "terse" && "bg-sky-700 text-white rounded-lg", "p-1"]} href={"/#{@path}"}>Voluble</.link>
    </div>
    """
  end

  attr :volubility, :string, default: "voluble", doc: "true when checked"
  attr :path, :string
  attr :page, :any
  attr :has_terse_version, :boolean, default: false
  def post_header(assigns) do
    ~H"""
    <header class="can-content">
      <h1 class="col-span-2"><%= @page.title %></h1>
      <div class="-mt-4 text-sm leading-6 text-zinc-600 flex justify-between items-end">
        <div>
          <%= if @page.date do %>
            <%= @page.date %>
          <% end %>
          in <.link navigate={~p"/posts"}>Posts</.link>
        </div>
        <.volubility_switcher :if={@has_terse_version} volubility={@volubility} path={@path} />
      </div>
    </header>
    """

  #   <div>
  #     <div :if={@header_badge != []} >
  #       <%= render_slot(@header_badge) %>
  #     </div>
  #     <h1>
  #       <%= render_slot(@inner_block) %>
  #     </h1>
  #     <p :if={@subtitle != []} class="-mt-4 text-sm leading-6 text-zinc-600">
  #       <%= render_slot(@subtitle) %>
  #     </p>
  #   </div>
  #   <div class="flex-none"><%= render_slot(@actions) %></div>
  # </header>


  end


  attr :volubility, :string, default: "voluble", doc: "true when checked"
  attr :path, :string
  attr :has_terse_version, :boolean, default: false
  def particle_header(assigns) do
    ~H"""
    <header class="can-content mb-6">
      <div>
        <.badge text={@page.section} />
      </div>
      <h1 class="col-span-full"><%= @page.title %></h1>
      <div class="-mt-4 text-sm leading-6 text-zinc-600 flex justify-between">
        <div>
          <%= if @page.date do %>
            <%= @page.date %>
          <% end %>
          in <.link navigate={~p"/particles"}>Particles</.link>
        </div>
        <.volubility_switcher :if={@has_terse_version} volubility={@volubility} path={@path} />
      </div>
    </header>
    """
  end

end

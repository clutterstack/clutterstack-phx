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
    <header>
      <h1 class="col-span-2"><%= @page.title %></h1>
      <div class="-mt-4 text-sm leading-6 text-zinc-600 dark:text-zinc-300 flex justify-between items-end">
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
  attr :page, :string
  def particle_header(assigns) do
    ~H"""
    <header class="mb-6">
      <div>
        <.badge text={@page.section} />
      </div>
      <h1 class="col-span-full"><%= @page.title %></h1>
      <div class="-mt-4 text-sm leading-6 text-zinc-600 dark:text-300 flex justify-between">
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

  attr :prev_post, :map, default: nil
  attr :next_post, :map, default: nil
  def post_navigation(assigns) do
    ~H"""
    <nav class="mb-4 md:my-0 md:mx-0  text-sm md:col-start-2 md:row-start-1 order-first md:order-none">
      <div class="pt-2 flex flex-wrap gap-2 md:flex-col md:space-y-2">
        <%= if @prev_post do %>
          <% prev_page = Path.basename(@prev_post.path) %>
          <div class="flex-1 text-left md:flex-none">
            <.link
              navigate={~p"/posts/#{prev_page}"}
              class="text-sky-700 dark:text-sky-200 hover:underline decoration-dashed"
            >
              <span class="font-bold">Prev: </span><%= @prev_post.title %>
            </.link>
          </div>
        <% end %>
        <%= if @next_post do %>
          <% next_page = Path.basename(@next_post.path) %>
          <div class="flex-1 text-right md:text-left md:flex-none">
            <.link
              navigate={~p"/posts/#{next_page}"}
              class="text-sky-700 dark:text-sky-200 hover:underline decoration-dashed"
            >
              <span class="font-bold">Next: </span><%= @next_post.title %>
            </.link>
          </div>
        <% end %>
      </div>
    </nav>
    """
  end

end

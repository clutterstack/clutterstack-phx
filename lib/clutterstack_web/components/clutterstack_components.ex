defmodule ClutterstackWeb.ClutterstackComponents do
  @moduledoc """
  Components for Clutterstack site
  """
  use Phoenix.Component
  use ClutterstackWeb, :verified_routes

  @doc """
  Provides a list of title links next to entry dates.
  Takes a list of "skinny" entries.
  """

  attr :items, :list
  def particle_list(assigns) do
    ~H"""
    <section class="mb-4">
      <ul>
        <%= for item <- @items do %>
          <li class="mt-2 mb-2">
            <span class="text-sm text-zinc-600 dark:text-zinc-300"><%= item.date %></span>
            <span class="text-base text-navy-900">
              <.link href={"/" <> URI.decode(item.path)} >
              <%= item.title %></.link>
            </span>
            <span :if={item.kind == "particle"}><.badge text="particle"/></span>
            <span :if={item.section != nil}><.badge text={item.section}/></span>
            </li>
        <% end %>
      </ul>
    </section>
    """
  end

  @doc """
  Provides a list of title links next to entry dates.
  Takes a list of "skinny" entries.
  """

  attr :markparticles, :boolean, default: false
  attr :items, :list
  def link_list(assigns) do
    ~H"""
    <section class="mb-4">
      <ul>
        <%= for item <- @items do %>
          <li class="mt-2 mb-2">
            <span class="text-sm text-zinc-600 dark:text-zinc-300"><%= item.date %></span>
            <span class="text-base mr-2">
              <.link href={"/" <> URI.decode(item.path)} >
              <%= item.title %></.link>
            </span>
            <span :if={@markparticles and item.kind == "particle"}>
              <.badge text="particle"/>
            </span>
          </li>
        <% end %>
      </ul>
    </section>
    """
  end

  @doc """
  Renders the page body -- needs to be passed a page though.
  Not tested. Good for particle transclusion?
  """
  attr :page, :map, required: true
  def transclude(assigns) do
    ~H"""
    <section class="can-content">
      <%= Phoenix.HTML.raw @page.body %>
    </section>
    """
  end

  @doc """
  Renders a badge-stlye span with text inside
  """

  attr :text, :string, default: nil
  def badge(assigns) do
    ~H"""
    <span class="bg-zinc-200 dark:bg-zinc-600 text-zinc-800 dark:text-zinc-100 rounded-xl text-xs px-2">
      <%= @text %>
    </span>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def subheader(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h2>
          <%= render_slot(@inner_block) %>
        </h2>
        <p :if={@subtitle != []} class="-mt-4 text-sm leading-6 text-zinc-600 dark:text-zinc-300">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end

end

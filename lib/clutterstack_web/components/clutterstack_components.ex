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

  attr :markparticles, :boolean, default: false
  attr :items, :list
  def link_list(assigns) do
    ~H"""
    <section class="mb-4">
      <ul>
        <%= for item <- @items do %>
          <li class="mt-2 mb-2 leading-6">
            <span class="text-sm text-zinc-600"><%= item.date %></span>
            <span class="text-base text-navy-900">
              <.link href={"/" <> URI.decode(item.path)} >
              <%= if @markparticles do %>
                <%= if item.kind == "particle" do %>(Particle) <% end %>
              <% end %>
              <%= item.title %></.link>
            </span>
          </li>
        <% end %>
      </ul>
    </section>
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
        <p :if={@subtitle != []} class="-mt-4 text-sm leading-6 text-zinc-600">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end

end

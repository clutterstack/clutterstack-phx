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
  def link_list(assigns) do
    ~H"""
    <section>
      <ul>
        <div>
          <%= for item <- @items do %>
            <li>
              <span class="mt-2 mb-2 text-sm leading-6 text-zinc-600"><%= item.date %></span>
              <span class="text-l font-bold text-navy-900">
                <.link href={"/" <> URI.decode(item.path)} ><%= item.title %></.link>
              </span>
            </li>
          <% end %>
        </div>
      </ul>
    </section>
    """
  end

end

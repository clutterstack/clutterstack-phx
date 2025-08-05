defmodule ClutterstackWeb.Components.Icons do
  use Phoenix.Component

  # Mark SVG files as external resources for recompilation
  @external_resource Path.join([__DIR__, "../../../assets/svg/bluesky.svg"])
  @external_resource Path.join([__DIR__, "../../../assets/svg/rss.svg"])
  @external_resource Path.join([__DIR__, "../../../assets/svg/github.svg"])

  # Read SVG files at compile time
  @bluesky_svg File.read!(Path.join([__DIR__, "../../../assets/svg/bluesky.svg"]))
  @rss_svg File.read!(Path.join([__DIR__, "../../../assets/svg/rss.svg"]))
  @github_svg File.read!(Path.join([__DIR__, "../../../assets/svg/github.svg"]))

  @doc """
  Renders the Bluesky icon
  """
  def bluesky(assigns) do
    assigns = assign(assigns, :svg_content, @bluesky_svg)
    
    ~H"""
    <%= Phoenix.HTML.raw(@svg_content) %>
    """
  end

  @doc """
  Renders the RSS icon
  """
  def rss(assigns) do
    assigns = assign(assigns, :svg_content, @rss_svg)
    
    ~H"""
    <%= Phoenix.HTML.raw(@svg_content) %>
    """
  end

  @doc """
  Renders the GitHub icon
  """
  def github(assigns) do
    assigns = assign(assigns, :svg_content, @github_svg)
    
    ~H"""
    <%= Phoenix.HTML.raw(@svg_content) %>
    """
  end
end
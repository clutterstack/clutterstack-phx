defmodule ClutterstackWeb.SEO do
  @moduledoc """
  Helper functions for generating SEO meta tags from blog entry data.
  Follows 2025 SEO best practices focusing on semantic search and user intent.
  """

  @doc """
  Builds meta tags for SEO from an entry's data.
  
  Returns a map with keys:
  - description: Meta description (max 160 chars)
  - og_title: Open Graph title
  - og_description: Open Graph description
  - og_type: Open Graph type (article for posts/particles)
  - og_tags: List of keywords for og:article:tag
  """
  def build_meta_tags(entry) do
    description = extract_description(entry)
    keywords = extract_keywords(entry)
    
    %{
      description: description,
      og_title: entry.title,
      og_description: description,
      og_type: og_type_for_kind(entry.kind),
      og_tags: keywords,
      twitter_title: entry.title,
      twitter_description: description
    }
  end

  @doc """
  Extracts or generates a meta description from entry content.
  Priority: meta["description"] > first 160 chars of body > fallback to title.
  """
  def extract_description(entry) do
    cond do
      # Check if description exists in meta
      entry.meta["description"] ->
        truncate_text(entry.meta["description"], 160)
      
      # Generate from body content
      entry.body && String.length(entry.body) > 0 ->
        entry.body
        |> strip_html_tags()
        |> String.trim()
        |> truncate_text(160)
      
      # Fallback to title
      true ->
        "#{entry.title} - Clutterstack"
    end
  end

  @doc """
  Extracts keywords from entry meta, returning as list of strings.
  Keywords in frontmatter are stored as YAML list in the meta field.
  """
  def extract_keywords(entry) do
    case entry.meta["keywords"] do
      keywords when is_list(keywords) -> keywords
      _ -> []
    end
  end

  @doc """
  Generates canonical URL for an entry.
  """
  def canonical_url(entry, _conn) do
    base_url = ClutterstackWeb.Endpoint.url()
    path = case entry.kind do
      "post" -> "/posts/#{Path.basename(entry.path)}"
      "particle" -> 
        parts = String.split(entry.path, "/")
        theme = Enum.at(parts, 1, "")
        page = Enum.at(parts, 2, "")
        "/particles/#{theme}/#{page}"
      _ -> "/#{entry.path}"
    end
    "#{base_url}#{path}"
  end

  # Private helper functions

  defp og_type_for_kind("post"), do: "article"
  defp og_type_for_kind("particle"), do: "article"  
  defp og_type_for_kind(_), do: "website"

  defp strip_html_tags(html_string) do
    case Floki.parse_fragment(html_string) do
      {:ok, parsed} ->
        parsed
        |> Floki.text(sep: " ")
        |> String.replace(~r/\s+/, " ")
        |> String.trim()

      # Fallback if parsing fails
      {:error, _} ->
        html_string
        |> String.replace(~r/<[^>]*>/, "")
        |> String.replace(~r/\s+/, " ")
        |> String.trim()
    end
  end

  defp truncate_text(text, max_length) do
    if String.length(text) <= max_length do
      text
    else
      text
      |> String.slice(0, max_length - 3)
      |> String.trim()
      |> Kernel.<>("...")
    end
  end
end
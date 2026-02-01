defmodule Clutterstack.SitemapperTest do
  use Clutterstack.DataCase

  alias Clutterstack.Sitemapper
  alias Clutterstack.Entries

  @sitemap_dir "priv/static/sitemaps/"

  setup do
    # Clean sitemap directory before each test
    File.rm_rf!(@sitemap_dir)
    File.mkdir_p!(@sitemap_dir)
    :ok
  end

  describe "parse_date/1" do
    test "parses valid ISO8601 date string" do
      result = Sitemapper.parse_date("2024-03-15")
      assert result == ~D[2024-03-15]
    end

    test "returns nil for invalid date string" do
      result = Sitemapper.parse_date("not-a-date")
      assert result == nil
    end

    test "returns nil for non-string input" do
      result = Sitemapper.parse_date(nil)
      assert result == nil
    end
  end

  describe "content_age_in_months/1" do
    test "calculates age for recent date" do
      # Date from 3 months ago
      date = Date.utc_today() |> Date.add(-90)
      date_string = Date.to_iso8601(date)

      result = Sitemapper.content_age_in_months(date_string)
      assert result == 3
    end

    test "calculates age for old date" do
      # Date from 1 year ago (365 days / 30 = ~12 months)
      date = Date.utc_today() |> Date.add(-365)
      date_string = Date.to_iso8601(date)

      result = Sitemapper.content_age_in_months(date_string)
      assert result == 12
    end

    test "returns nil for invalid date" do
      result = Sitemapper.content_age_in_months("invalid")
      assert result == nil
    end

    test "returns nil for nil input" do
      result = Sitemapper.content_age_in_months(nil)
      assert result == nil
    end
  end

  describe "determine_changefreq/1" do
    test "returns :monthly for recent content (< 6 months)" do
      # Date from 3 months ago
      date = Date.utc_today() |> Date.add(-90)
      date_string = Date.to_iso8601(date)

      result = Sitemapper.determine_changefreq(date_string)
      assert result == :monthly
    end

    test "returns :yearly for old content (>= 6 months)" do
      # Date from 1 year ago
      date = Date.utc_today() |> Date.add(-365)
      date_string = Date.to_iso8601(date)

      result = Sitemapper.determine_changefreq(date_string)
      assert result == :yearly
    end

    test "returns :yearly as fallback for invalid date" do
      result = Sitemapper.determine_changefreq("invalid")
      assert result == :yearly
    end

    test "returns :yearly as fallback for nil" do
      result = Sitemapper.determine_changefreq(nil)
      assert result == :yearly
    end
  end

  describe "entry_to_sitemap_url/1" do
    test "converts entry with recent date" do
      date = Date.utc_today() |> Date.add(-90) |> Date.to_iso8601()

      entry = %Clutterstack.Entries.Entry{
        path: "posts/test-post",
        date: date
      }

      result = Sitemapper.entry_to_sitemap_url(entry)

      assert result.loc == "https://clutterstack.com/posts/test-post"
      assert result.changefreq == :monthly
      assert result.priority == 0.8
      # Don't assert exact date as it's calculated dynamically
      assert result.lastmod != nil
    end

    test "converts entry with old date" do
      date = Date.utc_today() |> Date.add(-365) |> Date.to_iso8601()

      entry = %Clutterstack.Entries.Entry{
        path: "posts/old-post",
        date: date
      }

      result = Sitemapper.entry_to_sitemap_url(entry)

      assert result.loc == "https://clutterstack.com/posts/old-post"
      assert result.changefreq == :yearly
      assert result.priority == 0.8
    end

    test "converts entry with invalid date" do
      entry = %Clutterstack.Entries.Entry{
        path: "posts/test-post",
        date: "invalid-date"
      }

      result = Sitemapper.entry_to_sitemap_url(entry)

      assert result.loc == "https://clutterstack.com/posts/test-post"
      assert result.lastmod == nil
      assert result.changefreq == :yearly
      assert result.priority == 0.8
    end
  end

  describe "generate_sitemap/0" do
    test "generates sitemap with entries" do
      # Create test entries
      recent_date = Date.utc_today() |> Date.add(-90) |> Date.to_iso8601()
      old_date = Date.utc_today() |> Date.add(-365) |> Date.to_iso8601()

      {:ok, _entry1} = Entries.create_entry(%{
        title: "Recent Post",
        path: "posts/recent-post",
        date: recent_date,
        kind: "post",
        body: "Recent content",
        meta: "{}"
      })

      {:ok, _entry2} = Entries.create_entry(%{
        title: "Old Post",
        path: "posts/old-post",
        date: old_date,
        kind: "post",
        body: "Old content",
        meta: "{}"
      })

      # Generate sitemap
      {:ok, _result} = Sitemapper.generate_sitemap()

      # Verify sitemap file was created
      sitemap_files = File.ls!(@sitemap_dir)
      assert length(sitemap_files) > 0

      # Read and verify sitemap content
      [first_file | _] = sitemap_files
      sitemap_content = File.read!(Path.join(@sitemap_dir, first_file))

      # Verify homepage is included with priority 1.0
      assert sitemap_content =~ "<loc>https://clutterstack.com/</loc>"
      assert sitemap_content =~ "<priority>1.0</priority>"

      # Verify index pages are included with priority 0.6
      assert sitemap_content =~ "<loc>https://clutterstack.com/particles</loc>"
      assert sitemap_content =~ "<loc>https://clutterstack.com/posts</loc>"
      assert sitemap_content =~ "<priority>0.6</priority>"

      # Verify entries are included
      assert sitemap_content =~ "<loc>https://clutterstack.com/posts/recent-post</loc>"
      assert sitemap_content =~ "<loc>https://clutterstack.com/posts/old-post</loc>"

      # Verify content entries have priority 0.8
      assert sitemap_content =~ "<priority>0.8</priority>"

      # Verify lastmod tags are present
      assert sitemap_content =~ "<lastmod>"

      # Verify changefreq tags are present
      assert sitemap_content =~ "<changefreq>monthly</changefreq>"
      assert sitemap_content =~ "<changefreq>yearly</changefreq>"
      assert sitemap_content =~ "<changefreq>weekly</changefreq>"
    end

    test "generates sitemap with no entries" do
      # Generate sitemap with empty database
      {:ok, _result} = Sitemapper.generate_sitemap()

      # Verify sitemap file was created
      sitemap_files = File.ls!(@sitemap_dir)
      assert length(sitemap_files) > 0

      # Read and verify sitemap content still includes static pages
      [first_file | _] = sitemap_files
      sitemap_content = File.read!(Path.join(@sitemap_dir, first_file))

      # Verify homepage and index pages are included
      assert sitemap_content =~ "<loc>https://clutterstack.com/</loc>"
      assert sitemap_content =~ "<loc>https://clutterstack.com/particles</loc>"
      assert sitemap_content =~ "<loc>https://clutterstack.com/posts</loc>"
    end
  end
end

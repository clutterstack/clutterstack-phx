defmodule ClutterstackWeb.RedirectPlugTest do
  use ClutterstackWeb.ConnCase, async: true
  alias ClutterstackWeb.RedirectPlug

  describe "hostname-based redirects" do
    setup do
      # Initialize plug with test configuration
      opts = RedirectPlug.init([])
      %{opts: opts}
    end

    test "redirects hosts in redirect_from_hosts to canonical_host", %{opts: opts} do
      # Mock a redirect_from_hosts entry for this test
      opts = %{canonical_host: "example.com", redirect_from_hosts: ["test.fly.dev"]}

      conn = build_test_conn(:get, "http://test.fly.dev/posts/article")
      conn = RedirectPlug.call(conn, opts)

      assert conn.status == 301
      assert conn.halted
      assert get_resp_header(conn, "location") == ["https://example.com/posts/article"]
    end

    test "preserves path correctly", %{opts: opts} do
      opts = %{canonical_host: "example.com", redirect_from_hosts: ["test.fly.dev"]}

      conn = build_test_conn(:get, "http://test.fly.dev/particles/elixir/my-particle")
      conn = RedirectPlug.call(conn, opts)

      assert conn.status == 301
      assert get_resp_header(conn, "location") == [
               "https://example.com/particles/elixir/my-particle"
             ]
    end

    test "preserves query string parameters", %{opts: opts} do
      opts = %{canonical_host: "example.com", redirect_from_hosts: ["test.fly.dev"]}

      conn = build_test_conn(:get, "http://test.fly.dev/posts/article?utm_source=twitter&ref=123")
      conn = RedirectPlug.call(conn, opts)

      assert conn.status == 301
      assert get_resp_header(conn, "location") == [
               "https://example.com/posts/article?utm_source=twitter&ref=123"
             ]
    end

    test "handles empty query string without trailing question mark", %{opts: opts} do
      opts = %{canonical_host: "example.com", redirect_from_hosts: ["test.fly.dev"]}

      conn = build_test_conn(:get, "http://test.fly.dev/posts/article")
      conn = RedirectPlug.call(conn, opts)

      assert conn.status == 301
      location = get_resp_header(conn, "location") |> List.first()
      refute String.ends_with?(location, "?")
      assert location == "https://example.com/posts/article"
    end

    test "does NOT redirect canonical_host", %{opts: opts} do
      opts = %{canonical_host: "example.com", redirect_from_hosts: ["test.fly.dev"]}

      conn = build_test_conn(:get, "http://example.com/posts/article")
      conn = RedirectPlug.call(conn, opts)

      refute conn.halted
      refute conn.status == 301
    end

    test "does NOT redirect other hostnames not in the list", %{opts: opts} do
      opts = %{canonical_host: "example.com", redirect_from_hosts: ["test.fly.dev"]}

      conn = build_test_conn(:get, "http://localhost/posts/article")
      conn = RedirectPlug.call(conn, opts)

      refute conn.halted
      refute conn.status == 301
    end

    test "includes correct location header with https scheme", %{opts: opts} do
      opts = %{canonical_host: "example.com", redirect_from_hosts: ["test.fly.dev"]}

      conn = build_test_conn(:get, "http://test.fly.dev/posts/article")
      conn = RedirectPlug.call(conn, opts)

      location = get_resp_header(conn, "location") |> List.first()
      assert String.starts_with?(location, "https://")
    end

    test "halts plug pipeline after redirect", %{opts: opts} do
      opts = %{canonical_host: "example.com", redirect_from_hosts: ["test.fly.dev"]}

      conn = build_test_conn(:get, "http://test.fly.dev/posts/article")
      conn = RedirectPlug.call(conn, opts)

      assert conn.halted
    end
  end

  describe "path-based redirects (ETS lookup)" do
    setup do
      # Create ETS table for testing if it doesn't exist
      unless :ets.whereis(:redirects) != :undefined do
        :ets.new(:redirects, [:named_table, :public, read_concurrency: true])
      end

      # Clean up any existing entries
      :ets.delete_all_objects(:redirects)

      opts = RedirectPlug.init([])

      on_exit(fn ->
        if :ets.whereis(:redirects) != :undefined do
          :ets.delete_all_objects(:redirects)
        end
      end)

      %{opts: opts}
    end

    test "redirects when path is in ETS table", %{opts: opts} do
      # Insert a redirect into ETS
      :ets.insert(:redirects, {"/old-path", "new-path"})

      conn = build_test_conn(:get, "http://example.com/old-path")
      conn = RedirectPlug.call(conn, opts)

      assert conn.status == 301
      assert conn.halted
      assert get_resp_header(conn, "location") == ["/new-path"]
    end

    test "does not redirect when path is not in ETS table", %{opts: opts} do
      conn = build_test_conn(:get, "http://example.com/some-other-path")
      conn = RedirectPlug.call(conn, opts)

      refute conn.halted
      refute conn.status == 301
    end

    test "path-based redirects work independently of hostname redirects", %{opts: opts} do
      :ets.insert(:redirects, {"/old-url", "new-url"})
      opts = %{canonical_host: "example.com", redirect_from_hosts: ["test.fly.dev"]}

      # Should still do path redirect on canonical host
      conn = build_test_conn(:get, "http://example.com/old-url")
      conn = RedirectPlug.call(conn, opts)

      assert conn.status == 301
      assert get_resp_header(conn, "location") == ["/new-url"]
    end
  end

  # Helper function to build test connections with custom host
  defp build_test_conn(method, url) do
    uri = URI.parse(url)

    conn = Plug.Test.conn(method, uri.path || "/")

    conn
    |> Map.put(:host, uri.host)
    |> Map.put(:query_string, uri.query || "")
    |> Map.put(:request_path, uri.path || "/")
  end
end

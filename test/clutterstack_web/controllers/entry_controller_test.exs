defmodule ClutterstackWeb.EntryControllerTest do
  use ClutterstackWeb.ConnCase

  import Clutterstack.EntriesFixtures

  @create_attrs %{meta: "some meta", date: "some date", path: "some path", title: "some title", body: "some body", kind: "some kind", section: "some section"}
  @update_attrs %{meta: "some updated meta", date: "some updated date", path: "some updated path", title: "some updated title", body: "some updated body", kind: "some updated kind", section: "some updated section"}
  @invalid_attrs %{meta: nil, date: nil, path: nil, title: nil, body: nil, kind: nil, section: nil}

  describe "index" do
    test "lists all entries", %{conn: conn} do
      conn = get(conn, ~p"/entries")
      assert html_response(conn, 200) =~ "Listing Entries"
    end
  end

  describe "new entry" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/entries/new")
      assert html_response(conn, 200) =~ "New Entry"
    end
  end

  describe "create entry" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/entries", entry: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/entries/#{id}"

      conn = get(conn, ~p"/entries/#{id}")
      assert html_response(conn, 200) =~ "Entry #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/entries", entry: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Entry"
    end
  end

  describe "edit entry" do
    setup [:create_entry]

    test "renders form for editing chosen entry", %{conn: conn, entry: entry} do
      conn = get(conn, ~p"/entries/#{entry}/edit")
      assert html_response(conn, 200) =~ "Edit Entry"
    end
  end

  describe "update entry" do
    setup [:create_entry]

    test "redirects when data is valid", %{conn: conn, entry: entry} do
      conn = put(conn, ~p"/entries/#{entry}", entry: @update_attrs)
      assert redirected_to(conn) == ~p"/entries/#{entry}"

      conn = get(conn, ~p"/entries/#{entry}")
      assert html_response(conn, 200) =~ "some updated meta"
    end

    test "renders errors when data is invalid", %{conn: conn, entry: entry} do
      conn = put(conn, ~p"/entries/#{entry}", entry: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Entry"
    end
  end

  describe "delete entry" do
    setup [:create_entry]

    test "deletes chosen entry", %{conn: conn, entry: entry} do
      conn = delete(conn, ~p"/entries/#{entry}")
      assert redirected_to(conn) == ~p"/entries"

      assert_error_sent 404, fn ->
        get(conn, ~p"/entries/#{entry}")
      end
    end
  end

  defp create_entry(_) do
    entry = entry_fixture()
    %{entry: entry}
  end

  describe "show_post with various URL patterns" do
    setup do
      post = entry_fixture(%{
        kind: "post",
        path: "posts/2025-01-test-post",
        title: "Test Post",
        body: "<p>Test content</p>",
        date: "2025-01-01",
        section: "",
        meta: Jason.encode!(%{"versions" => ["terse"]})
      })
      %{post: post}
    end

    test "handles post path without volubility parameter (default voluble)", %{conn: conn, post: _post} do
      conn = get(conn, "/posts/2025-01-test-post")
      assert html_response(conn, 200) =~ "Test Post"
    end

    test "handles post path with explicit terse", %{conn: conn, post: _post} do
      conn = get(conn, "/posts/2025-01-test-post/terse")
      assert html_response(conn, 200) =~ "Test Post"
    end

    test "handles post path with explicit voluble", %{conn: conn, post: _post} do
      conn = get(conn, "/posts/2025-01-test-post/voluble")
      assert html_response(conn, 200) =~ "Test Post"
    end

    test "handles malformed post path with multiple segments after page (bug fix test)", %{conn: conn} do
      # This was causing CaseClauseError before the fix
      # The path matches as page="particles" and volubility=["elixir", "2025-01-29-asdf-switch-erlang"]
      conn = get(conn, "/posts/particles/elixir/2025-01-29-asdf-switch-erlang")
      # Should return 404 since this path doesn't exist, not crash
      assert html_response(conn, 404)
    end

    test "returns 404 for non-existent post", %{conn: conn} do
      conn = get(conn, "/posts/non-existent-post")
      assert html_response(conn, 404)
    end
  end

  describe "show_particle with various URL patterns" do
    setup do
      particle = entry_fixture(%{
        kind: "particle",
        path: "particles/elixir/2025-01-test-particle",
        title: "Test Particle",
        body: "<p>Test particle content</p>",
        date: "2025-01-01",
        section: "elixir",
        meta: Jason.encode!(%{"versions" => ["terse"]})
      })
      %{particle: particle}
    end

    test "handles particle path without volubility parameter (default voluble)", %{conn: conn, particle: _particle} do
      conn = get(conn, "/particles/elixir/2025-01-test-particle")
      assert html_response(conn, 200) =~ "Test Particle"
    end

    test "handles particle path with explicit terse", %{conn: conn, particle: _particle} do
      conn = get(conn, "/particles/elixir/2025-01-test-particle/terse")
      assert html_response(conn, 200) =~ "Test Particle"
    end

    test "handles particle path with explicit voluble", %{conn: conn, particle: _particle} do
      conn = get(conn, "/particles/elixir/2025-01-test-particle/voluble")
      assert html_response(conn, 200) =~ "Test Particle"
    end

    test "handles malformed particle path with multiple segments", %{conn: conn} do
      # Test that multi-segment volubility lists are handled gracefully
      conn = get(conn, "/particles/elixir/2025-01-test-particle/something/else")
      # Should still work, just using the first segment as volubility
      assert html_response(conn, 200) =~ "Test Particle"
    end

    test "returns 404 for non-existent particle", %{conn: conn} do
      conn = get(conn, "/particles/elixir/non-existent-particle")
      assert html_response(conn, 404)
    end

    test "returns 404 for non-existent theme", %{conn: conn} do
      conn = get(conn, "/particles/nonexistent/some-particle")
      assert html_response(conn, 404)
    end
  end
end

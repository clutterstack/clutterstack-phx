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
end

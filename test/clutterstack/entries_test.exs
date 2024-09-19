defmodule Clutterstack.EntriesTest do
  use Clutterstack.DataCase

  alias Clutterstack.Entries

  describe "entries" do
    alias Clutterstack.Entries.Entry

    import Clutterstack.EntriesFixtures

    @invalid_attrs %{meta: nil, date: nil, path: nil, title: nil, body: nil, kind: nil, section: nil}

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Entries.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Entries.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      valid_attrs = %{meta: "some meta", date: "some date", path: "some path", title: "some title", body: "some body", kind: "some kind", section: "some section"}

      assert {:ok, %Entry{} = entry} = Entries.create_entry(valid_attrs)
      assert entry.meta == "some meta"
      assert entry.date == "some date"
      assert entry.path == "some path"
      assert entry.title == "some title"
      assert entry.body == "some body"
      assert entry.kind == "some kind"
      assert entry.section == "some section"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entries.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      update_attrs = %{meta: "some updated meta", date: "some updated date", path: "some updated path", title: "some updated title", body: "some updated body", kind: "some updated kind", section: "some updated section"}

      assert {:ok, %Entry{} = entry} = Entries.update_entry(entry, update_attrs)
      assert entry.meta == "some updated meta"
      assert entry.date == "some updated date"
      assert entry.path == "some updated path"
      assert entry.title == "some updated title"
      assert entry.body == "some updated body"
      assert entry.kind == "some updated kind"
      assert entry.section == "some updated section"
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Entries.update_entry(entry, @invalid_attrs)
      assert entry == Entries.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Entries.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Entries.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Entries.change_entry(entry)
    end
  end
end

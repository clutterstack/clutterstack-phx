defmodule Clutterstack.EntriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Clutterstack.Entries` context.
  """

  @doc """
  Generate a entry.
  """
  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(%{
        body: "some body",
        date: "some date",
        kind: "some kind",
        meta: "some meta",
        path: "some path",
        section: "some section",
        title: "some title"
      })
      |> Clutterstack.Entries.create_entry()

    entry
  end
end

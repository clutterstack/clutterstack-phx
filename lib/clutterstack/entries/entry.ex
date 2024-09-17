defmodule Clutterstack.Entries.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :meta, :string
    field :date, :string
    field :path, :string
    field :title, :string
    field :body, :string
    field :kind, :string
    field :section, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:title, :path, :section, :date, :kind, :body, :meta])
    |> validate_required([:title, :path, :section, :date, :kind, :body, :meta])
  end
end

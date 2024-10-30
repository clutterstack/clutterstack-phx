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
    # Virtual association - looks up redirects pointing to this entry
    has_many :redirects, Clutterstack.Entries.Redirect,
      foreign_key: :new_path,
      references: :path
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:title, :path, :section, :date, :kind, :body, :meta])
    |> validate_required([:title, :path, :date, :kind, :body, :meta])
    |> unique_constraint([:path])
  end
end

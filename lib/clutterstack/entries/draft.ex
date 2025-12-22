defmodule Clutterstack.Entries.Draft do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drafts" do
    field :meta, :string
    field :date, :string
    field :path, :string
    field :title, :string
    field :body, :string
    field :kind, :string
    field :section, :string
    field :private_key, :string
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(draft, attrs) do
    draft
    |> cast(attrs, [:title, :path, :section, :date, :kind, :body, :meta, :private_key])
    |> validate_required([:title, :path, :date, :kind, :body, :meta, :private_key])
    |> unique_constraint([:path])
  end
end

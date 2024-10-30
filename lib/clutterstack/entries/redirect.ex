defmodule Clutterstack.Entries.Redirect do
  use Ecto.Schema
  import Ecto.Changeset

  schema "redirects" do
    field :redirect_from, :string
    field :new_path, :string
    timestamps()
  end

  def changeset(redirect, attrs) do
    redirect
    |> cast(attrs, [:redirect_from, :new_path])
    |> validate_required([:redirect_from, :new_path])
    |> unique_constraint(:redirect_from)
  end

end

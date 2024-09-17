defmodule Clutterstack.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :title, :string
      add :path, :string
      add :section, :string
      add :date, :string
      add :kind, :string
      add :body, :string
      add :meta, :string

      timestamps(type: :utc_datetime)
    end
  end
end

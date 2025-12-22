defmodule Clutterstack.Repo.Migrations.CreateDrafts do
  use Ecto.Migration

  def change do
    create table(:drafts) do
      add :title, :text
      add :path, :text
      add :section, :text
      add :date, :text
      add :kind, :text
      add :body, :text
      add :meta, :text
      add :private_key, :string
      timestamps(type: :utc_datetime)
    end

    create unique_index(:drafts, [:path])
  end
end

defmodule Clutterstack.Repo.Migrations.AddRedirectsTable do
  use Ecto.Migration

  def change do
    create table(:redirects) do
      add :redirect_from, :string, null: false
      add :new_path, :string, null: false
      timestamps()
    end

    # Each old_path must be unique since it's what we match against
    create unique_index(:redirects, [:redirect_from])
    # Index new_path to help with lookups/joins
    create index(:redirects, [:new_path])
    # Add a foreign key constraint ensuring new_path exists in entries
  end
end

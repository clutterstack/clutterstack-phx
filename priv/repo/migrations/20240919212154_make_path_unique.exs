defmodule Clutterstack.Repo.Migrations.MakePathUnique do
  use Ecto.Migration

  def change do
    create unique_index(:entries, [:path])
  end
end

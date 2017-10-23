defmodule Writing.Repo.Migrations.CreateTagsTable do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :label, :string, default: ""

      timestamps()
    end

    create unique_index(:tags, [:label])
  end
end

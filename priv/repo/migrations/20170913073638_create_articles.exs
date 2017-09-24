defmodule Writing.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :slug, :string
      add :title, :string
      add :text, :text
      add :html, :text
      add :draft, :boolean, default: false, null: false
      add :image, :string
      add :published_at, :utc_datetime

      timestamps()
    end

  end
end

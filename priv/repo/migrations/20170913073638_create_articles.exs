defmodule Writing.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :body, :text
      add :draft, :boolean, default: false, null: false
      add :image, :string

      timestamps()
    end

  end
end

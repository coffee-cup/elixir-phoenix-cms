defmodule Writing.Repo.Migrations.CreateTagArticlesTable do
  use Ecto.Migration

  def change do
    create table(:articles_tags, primary_key: false) do
      add :article_id, references(:articles, on_delete: :delete_all, on_replace: :delete)
      add :tag_id, references(:tags, on_delete: :delete_all, on_replace: :delete)
    end
  end
end

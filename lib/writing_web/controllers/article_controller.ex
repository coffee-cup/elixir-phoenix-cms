defmodule WritingWeb.ArticleController do
  use WritingWeb, :controller

  alias Writing.Accounts
  alias Writing.Accounts.Article
  alias WritingWeb.ErrorView

  def index(conn, _params) do
    published = Accounts.list_articles(draft: false)
    drafts = Accounts.list_articles(draft: true)
    render(conn, "index.html", published: published, drafts: drafts, show_edit: true)
  end

  def new(conn, _params) do
    changeset = Accounts.change_article(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    case Accounts.create_article(article_params) do
      {:ok, article} ->
        conn
        |> redirect(to: article_path(conn, :show, article.slug))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug}) do
    case Accounts.get_article_by_slug(slug) do
      %Article{} = article ->
        render(conn, "show.html",
          article: article,
          title: Map.get(article, :title),
          image: Map.get(article, :image),
          description: String.slice(Map.get(article, :text), 0, 150) <> "...",
          tex: true
        )
      _ ->
        render(conn, ErrorView, "404.html")
    end
  end

  def edit(conn, %{"id" => id}) do
    article = Accounts.get_article!(id)
    changeset = Accounts.change_article(article)
    render(conn, "edit.html", article: article, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = Accounts.get_article!(id)

    case Accounts.update_article(article, article_params) do
      {:ok, article} ->
        conn
        |> redirect(to: article_path(conn, :show, article.slug))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", article: article, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = Accounts.get_article!(id)
    {:ok, _article} = Accounts.delete_article(article)

    conn
    |> redirect(to: article_path(conn, :index))
  end
end

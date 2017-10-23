defmodule WritingWeb.PageController do
  use WritingWeb, :controller

  alias Writing.Accounts

  def index(conn, _params) do
    conn
    |> render("index.html", articles: Accounts.list_articles(draft: false))
  end

  def tag(conn, %{"tag" => tag}) do
    conn
    |> assign(:tag, tag)
    |> assign(:title, "w. | " <> String.capitalize(tag))
    |> render("index.html", articles: Accounts.list_articles_tag(tag, false))
  end
end

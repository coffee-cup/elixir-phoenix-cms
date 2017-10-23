defmodule WritingWeb.PageController do
  use WritingWeb, :controller

  alias Writing.Accounts

  def index(conn, _params) do
    conn
    |> render("index.html", articles: Accounts.list_articles_draft(false))
  end

  def tag(conn, _params) do
    conn
    |> render("index.html", articles: Accounts.list_articles_draft(false))
  end
end

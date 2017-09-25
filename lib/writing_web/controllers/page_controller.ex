defmodule WritingWeb.PageController do
  use WritingWeb, :controller

  alias Writing.Accounts

  def index(conn, _params) do
    IO.inspect Application.get_env(:writing, :metadata)[:test]

    conn
    |> render("index.html", articles: Accounts.list_articles_draft(false))
  end
end

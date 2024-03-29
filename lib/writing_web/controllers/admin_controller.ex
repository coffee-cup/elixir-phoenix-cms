defmodule WritingWeb.AdminController do
  use WritingWeb, :controller

  alias Writing.Accounts

  plug :admin_check

  def index(conn, _params) do
    # render conn, "index.html"
    conn |> redirect(to: WritingWeb.Router.Helpers.article_path(conn, :index))
  end

  def login(conn, _params) do

    render conn, "login.html"
  end

  def logout(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> Writing.Guardian.Plug.sign_out
    |> redirect(to: "/")
  end

  def admin_check(conn, _) do
    conn
    |> assign(:admin_exists, Accounts.admin_exists?)
  end
end

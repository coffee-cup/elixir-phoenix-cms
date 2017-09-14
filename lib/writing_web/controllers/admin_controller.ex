defmodule WritingWeb.AdminController do
  use WritingWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
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
end

defmodule WritingWeb.AdminController do
  use WritingWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def login(conn, _params) do
    render conn, "login.html"
  end
end

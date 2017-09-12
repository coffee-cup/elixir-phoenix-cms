defmodule WritingWeb.PageController do
  use WritingWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

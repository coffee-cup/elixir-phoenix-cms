defmodule WritingWeb.PageControllerTest do
  use WritingWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get conn, page_path(conn, :index)
    assert html_response(conn, 200) != "w."
  end

  test "GET /tag/hello", %{conn: conn} do
    conn = get conn, page_path(conn, :tag, "hello")
    assert html_response(conn, 200) != "Hello"
  end
end

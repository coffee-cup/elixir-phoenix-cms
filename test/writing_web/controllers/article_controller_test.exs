defmodule WritingWeb.ArticleControllerTest do
  use WritingWeb.ConnCase, async: true

  alias Writing.Accounts

  @create_attrs %{text: "`some body", draft: true, image: "some image", title: "some title", slug: "some-title"}
  @update_attrs %{text: "some updated body", draft: false, image: "some updated image", title: "some updated title", slug: "some-updated-title"}
  @invalid_attrs %{text: nil, draft: nil, image: nil, title: nil}

  def fixture(:article) do
    {:ok, article} = Accounts.create_article(@create_attrs)
    article
  end

  describe "index" do
    test "lists all articles", %{conn: conn} do
      conn = login_user(conn)
      conn = get conn, article_path(conn, :index)
      assert html_response(conn, 200) =~ "Articles"
    end

    test "redirects when not logged in", %{conn: conn} do
      conn = get conn, article_path(conn, :index)
      assert redirected_to(conn) == "/login"
    end
  end

  describe "new article" do
    test "renders form", %{conn: conn} do
      conn = login_user conn
      conn = get conn, article_path(conn, :new)
      assert html_response(conn, 200) =~ "New Article"
    end

    test "redirects when user not logged in", %{conn: conn} do
      conn = get conn, article_path(conn, :new)
      assert redirected_to(conn) == "/login"
    end
  end

  describe "create article" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = login_user conn
      conn = post conn, article_path(conn, :create), article: @create_attrs

      assert %{slug: slug} = redirected_params(conn)
      assert redirected_to(conn) == article_path(conn, :show, slug)

      conn = get conn, article_path(conn, :show, slug)
      assert html_response(conn, 200) =~ Map.get(@create_attrs, :title)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = login_user conn
      conn = post conn, article_path(conn, :create), article: @invalid_attrs
      assert html_response(conn, 200) =~ "New Article"
    end
  end

  describe "edit article" do
    setup [:create_article]

    test "renders form for editing chosen article", %{conn: conn, article: article} do
      conn = login_user conn
      conn = get conn, article_path(conn, :edit, article)
      assert html_response(conn, 200) =~ "Edit Article"
    end
  end

  describe "update article" do
    setup [:create_article]

    test "redirects when data is valid", %{conn: conn, article: article} do
      conn = login_user conn
      conn = put conn, article_path(conn, :update, article), article: @update_attrs
      assert redirected_to(conn) == article_path(conn, :show, Map.get(@update_attrs, :slug))

      conn = get conn, article_path(conn, :show, Map.get(@update_attrs, :slug))
      assert html_response(conn, 200) =~ Map.get(@update_attrs, :title)
    end

    test "renders errors when data is invalid", %{conn: conn, article: article} do
      conn = login_user conn
      conn = put conn, article_path(conn, :update, article), article: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Article"
    end
  end

  # describe "delete article" do
  #   setup [:create_article]

  #   test "deletes chosen article", %{conn: conn, article: article} do
  #     conn = delete conn, article_path(conn, :delete, article)
  #     assert redirected_to(conn) == article_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get conn, article_path(conn, :show, article)
  #     end
  #   end
  # end

  defp create_article(_) do
    article = fixture(:article)
    {:ok, article: article}
  end

  defp login_user(%Plug.Conn{} = conn) do
    {:ok, user} = Accounts.create_user(%{
      auth_provider: "google",
      email: "test@email.com",
      first_name: "First",
      last_name: "Last"
    })

    conn =  guardian_login(conn, user)

    conn
  end
end

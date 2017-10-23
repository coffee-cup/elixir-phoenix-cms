defmodule Writing.AccountsTest do
  use Writing.DataCase, async: true

  alias Writing.Accounts

  describe "articles" do
    alias Writing.Accounts.Article

    @valid_attrs %{text: "some body", draft: false, image: "some image", title: "some title", slug: "some-title"}
    @valid_attrs_draft %{text: "some draft body", draft: true, image: "some image", title: "some title draft", slug: "some-title-draft"}
    @update_attrs %{text: "some updated body", draft: true, image: "some updated image", title: "some updated title", slug: "some-updated-title"}
    @invalid_attrs %{text: nil, draft: nil, image: nil, title: nil}

    def article_fixture(attrs \\ %{}) do
      {:ok, article} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_article()

      article
    end

    def tag_labels(%Article{} = article) do
      article.tags
      |> Enum.map(fn t -> Map.get(t, :label) end)
    end

    def scrub_time(%Article{} = article) do
      article
      |> Map.delete(:published_at)
      |> Map.delete(:inserted_at)
      |> Map.delete(:updated_at)
    end

    def articles_equal(articles1, articles2) when is_list(articles1) and is_list(articles2) do
      assert Enum.map(articles1, &scrub_time/1) == Enum.map(articles2, &scrub_time/1)
    end
    def articles_equal(%Article{} = article, articles2), do: articles_equal([article], articles2)
    def articles_equal(articles1, %Article{} = article), do: articles_equal(articles1, [article])

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      articles_equal(Accounts.list_articles(), article)
    end

    test "list_articles/1 returns filtered articles" do
      draft = article_fixture(@valid_attrs_draft)
      published = article_fixture(Map.put(@valid_attrs, :draft, false))
      articles_equal(Accounts.list_articles(draft: false), published)
      articles_equal(Accounts.list_articles(draft: true), draft)
    end

    test "list_articles_tag/2 returns filtered articles" do
      article = article_fixture(%{tags: "these, are,the,    tags"})
      articles_equal(Accounts.list_articles_tag("these", draft: false), article)
      articles_equal(Accounts.list_articles_tag("nothing", draft: false), [])
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      articles_equal(Accounts.get_article!(article.id), article)
    end

    test "create_article/1 with valid data creates a article" do
      assert {:ok, %Article{} = article} = Accounts.create_article(@valid_attrs)
      assert article.text == "some body"
      assert article.title == "some title"
    end

    test "creating an article converts text to html" do
      assert {:ok, %Article{} = article} = Accounts.create_article(Map.put(@valid_attrs, :text, "# Hello"))
      assert article.text == "# Hello"
      assert article.html == "<h1>Hello</h1>\n"
    end

    test "creating an article converts tags to models" do
      article = article_fixture(%{tags: "these, are,the,    tags"})
      articles_equal(Accounts.get_article!(article.id), article)
      assert (length article.tags) == 4
      labels = tag_labels(article)
      assert labels == ["these", "are", "the", "tags"]
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()
      assert {:ok, article} = Accounts.update_article(article, @update_attrs)
      assert %Article{} = article
      assert article.text == "some updated body"
      assert article.title == "some updated title"
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_article(article, @invalid_attrs)
      articles_equal([article], [Accounts.get_article!(article.id)])
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = Accounts.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = Accounts.change_article(article)
    end
  end

  describe "users" do
    alias Writing.Accounts.User

    @valid_attrs %{auth_provider: "some auth_provider", email: "some email", first_name: "some first_name", last_name: "some last_name"}
    @update_attrs %{auth_provider: "some updated auth_provider", email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name"}
    @invalid_attrs %{auth_provider: nil, email: nil, first_name: nil, last_name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.auth_provider == "some auth_provider"
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.auth_provider == "some updated auth_provider"
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end

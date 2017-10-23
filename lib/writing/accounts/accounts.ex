defmodule Writing.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Writing.Repo

  alias Writing.Accounts.Article

  @doc """
  Returns the list of articles that are draft true or false.

  `opts` is a keyword list specifiying if articles should
  be draft true or false. `opts[draft]` is false by default

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

      iex> list_articles(draft: true)
      [%Article{}, ...]

  """
  def list_articles(opts \\ []) do
    opts = Keyword.merge([
      draft: false
    ], opts)
    from(a in Article,
      where: a.draft == ^opts[:draft],
      preload: [:tags],
      order_by: [desc: :published_at, desc: :inserted_at])
    |> Repo.all()
  end

  @doc """
  Returns articles with a given `tag`.
  `tag` can be mutliple tags separated by "+" character.

  `opts` is a keyword list specifiying if articles should
  be draft true or false. `opts[draft]` is false by default

  ## Examples

      iex> list_articles_tag("hello+world", [draft: true])
      [%Article{}, ...]
  """
  def list_articles_tag(tag, opts \\ []) do
    opts = Keyword.merge([
      draft: false
    ], opts)
    tags = String.split(tag, "+")
    from(a in Article,
      preload: [:tags],
      join: t in assoc(a, :tags),
      where: a.draft == ^opts[:draft] and t.label in ^tags)
    |> Repo.all()
  end

  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id), do: Repo.get!(Article, id) |> Repo.preload(:tags)

  def get_article_by_slug(slug) do
    Repo.get_by(Article, slug: slug)
    |> Repo.preload(:tags)
  end

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{source: %Article{}}

  """
  def change_article(%Article{} = article) do
    Article.changeset(article, %{})
  end

  alias Writing.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user

  ## Examples

      iex> get_user(123)
      {:ok, %User{}}

      iex> get_user(456)
      {:error, "No user found"}
  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def admin_exists? do
    Repo.aggregate(User, :count, :id) >= 1
  end

  alias Writing.Accounts.Tag

  def create_tag(label) do
    %Tag{}
    |> Tag.changeset(%{label: label})
    |> Repo.insert()
  end

  def insert_and_get_all_tags([], _), do: []
  def insert_and_get_all_tags(labels) do
    labels
    |> Enum.map(fn label ->
        create_tag(label)
    end)

    Repo.all(from t in Tag, where: t.label in ^labels)
  end

  def get_tag(label) do
    Repo.get_by(Tag, label: label)
  end
end

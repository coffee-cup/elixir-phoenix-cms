defmodule Writing.Accounts.Article do
  use Ecto.Schema

  import Ecto.Changeset
  alias Writing.Accounts.Article
  alias Writing.Accounts
  alias Writing.Parser

  @timestamps_opts [type: Timex.Ecto.DateTime,
                    autogenerate: {Timex.Ecto.DateTime, :autogenerate, []}]

  schema "articles" do
    field :text, :string
    field :html, :string
    field :draft, :boolean, default: true
    field :image, :string
    field :slug, :string
    field :title, :string
    field :published_at, Timex.Ecto.DateTime
    many_to_many :tags, Writing.Accounts.Tag, join_through: "articles_tags"

    timestamps()
  end

  def format_date(%Article{} = article) do
    case article.published_at do
      nil -> format_date(article.inserted_at)
      _ -> format_date(article.published_at)
    end
  end
  def format_date(date) do
    date
    |> Timex.format!("%B %e. %Y", :strftime)
  end

  def tag_string(%Article{} = article, join_char \\ ".") do
    case Map.get(article, :tags) do
      %Ecto.Association.NotLoaded{} -> ""
      tags ->
        tags
        |> Enum.map(fn t -> Map.get(t, :label) end)
        |> Enum.join(join_char <> " ")
      end
  end

  @doc false
  def changeset(%Article{} = article, attrs) do
    article
    |> cast(attrs, [:slug, :title, :text, :draft, :image])
    |> validate_required([:slug, :title, :text, :draft])
    |> put_change(:html, Parser.to_html(get_text(attrs)))
    |> put_change(:published_at, get_published_date(article, attrs))
    |> unique_constraint(:slug)
    |> put_assoc(:tags, parse_tags(article, attrs))
  end

  # Convert tag string `"this, is, a, tag"`
  # into individual tag models in the db
  def parse_tags(article, attrs) do
    new_tags = (attrs["tags"] || attrs[:tags] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Accounts.insert_and_get_all_tags

    current_tags = case Map.get(article, :tags) do
      %Ecto.Association.NotLoaded{} -> []
      tags -> tags
    end

    new_tags ++ current_tags
  end

  # Get the Timex published date for the article.
  # A date is only returned if the article is going from
  # `article.draft` = true to false.
  defp get_published_date(article, %{draft: draft}), do: get_published_date(article, draft)
  defp get_published_date(article, %{"draft" => draft}), do: get_published_date(article, draft)
  defp get_published_date(article, "false"), do: get_published_date(article, false)
  defp get_published_date(article, false) do
    case article.draft do
      true -> Timex.now
      false -> article.published_at
    end
  end
  defp get_published_date(_, _), do: nil

  defp get_text(%{text: text}), do: text
  defp get_text(%{"text" => text}), do: text
  defp get_text(%{}), do: nil
end

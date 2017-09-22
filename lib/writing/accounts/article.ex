defmodule Writing.Accounts.Article do
  use Ecto.Schema

  import Ecto.Changeset
  alias Writing.Accounts.Article
  alias Writing.Parser

  schema "articles" do
    field :text, :string
    field :html, :string
    field :draft, :boolean, default: false
    field :image, :string
    field :slug, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Article{} = article, attrs) do
    article
    |> cast(attrs, [:slug, :title, :text, :draft, :image])
    |> validate_required([:slug, :title, :text, :draft])
    |> put_change(:html, Parser.to_html(get_text(attrs)))
    |> unique_constraint(:slug)
  end


  defp get_text(%{text: text}), do: text
  defp get_text(%{"text" => text}), do: text
  defp get_text(%{}), do: nil
end

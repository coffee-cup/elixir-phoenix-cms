defmodule Writing.Accounts.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias Writing.Accounts.Article


  schema "articles" do
    field :body, :string
    field :draft, :boolean, default: false
    field :image, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Article{} = article, attrs) do
    article
    |> cast(attrs, [:title, :body, :draft, :image])
    |> validate_required([:title, :body, :draft])
  end
end

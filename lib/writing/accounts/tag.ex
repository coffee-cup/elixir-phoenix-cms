defmodule Writing.Accounts.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Writing.Accounts.Tag


  schema "tags" do
    field :label, :string

    timestamps()
  end

  @doc false
  def changeset(%Tag{} = tag, attrs) do
    tag
    |> cast(attrs, [:label])
    |> validate_required([:label])
    |> unique_constraint(:label)
  end
end

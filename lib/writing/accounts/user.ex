defmodule Writing.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Writing.Accounts.User


  schema "users" do
    field :auth_provider, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :auth_provider, :first_name, :last_name])
    |> validate_required([:email, :auth_provider, :first_name, :last_name])
  end
end

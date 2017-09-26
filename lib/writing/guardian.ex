defmodule Writing.Guardian do
  use Guardian, otp_app: :writing

  alias Writing.Accounts
  alias Writing.Accounts.User

  # def for_token(%User{} = user), do: {:ok, "User:#{user.id}"}
  # def for_token(_), do: {:error, "Unknown resource type"}

  # def from_token("User:" <> id), do: {:ok, Repo.get(User, id)}
  # def from_token(_), do: {:error, "Unknown resource type"}

  def subject_for_token(%User{id: id}, _claims), do: {:ok, to_string(id)}
  def subject_for_token(_, _), do: {:error, :reason_for_error}

  def resource_from_claims(claims) do
    case Accounts.get_user(claims["sub"]) do
      %User{} = user -> {:ok, user}
      _ -> {:error, "Resource not found"}
    end
  end

  # def resource_from_claims(claims) do
  #   {:ok, find_me_a_resource(claims["sub"])}
  # end
  # def resource_from_claims(_claims) do
  #   {:error, :reason_for_error}
  # end
end
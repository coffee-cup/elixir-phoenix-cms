defmodule Writing.Accounts.AuthUser do
  @moduledoc """
  Retrieve the user information from an auth request
  """

  alias Ueberauth.Auth

  @doc """
  Creates user info from an Ueberauth authentication
  """
  def create_user_info(%Auth{} = auth) do
    {:ok, basic_info(auth)}
  end

  def basic_info(auth) do
    %{
      email: auth.info.email,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      auth_provider: to_string(auth.provider)
    }
  end
end
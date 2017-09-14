defmodule WritingWeb.AuthController do
  use WritingWeb, :controller

  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Writing.Accounts
  alias Writing.Accounts.AuthUser
  alias Writing.Accounts.User

  def request(conn, _params) do
    configure_session(conn, drop: true)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{uberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/admin/login")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case AuthUser.create_user_info(auth) do
      {:ok, user} ->
        sign_up_or_sign_in_user(conn, %{"user" => user})
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: admin_path(conn, :login))
    end
  end

  # def sign_in_user(conn, %{"user" => user}) do
  #   case Accounts.user_exists? do
  #     true ->
  #       # User already exists

  #     false ->
  #       # No user yet, we should create one

  #   end
  # end

  def sign_up_or_sign_in_user(conn, params) do
    case Accounts.admin_exists? do
      true ->
        sign_in_user(conn, params)
      false ->
        sign_up_user(conn, params)
    end
  end

  def sign_up_user(conn, %{"user" => user}) do
    IO.inspect user
    case Accounts.create_user(user) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> redirect(to: admin_path(conn, :index))
      {:error, reason} ->
        IO.inspect reason
        conn
        |> put_flash(:error, "Error creating user")
        |> redirect(to: admin_path(conn, :login))
    end
  end

  def sign_in_user(conn, %{"user" => user}) do
    case Accounts.get_user_by_email(user.email) do
      %User{} = user ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> redirect(to: admin_path(conn, :index))
      nil ->
        conn
        |> put_flash(:error, "Error logging in.")
        |> redirect(to: admin_path(conn, :login))
    end
  end

end
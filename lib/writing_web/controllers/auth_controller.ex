defmodule WritingWeb.AuthController do
  use WritingWeb, :controller

  plug Ueberauth

  alias Writing.Accounts
  alias Writing.Accounts.AuthUser
  alias Writing.Accounts.User

  def request(conn, _params) do
    configure_session(conn, drop: true)
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

  def sign_up_or_sign_in_user(conn, params) do
    case Accounts.admin_exists? do
      true ->
        sign_in_user(conn, params)
      false ->
        sign_up_user(conn, params)
    end
  end

  def sign_up_user(conn, %{"user" => user}) do
    case Accounts.create_user(user) do
      {:ok, user} ->
        auth_user(conn, user)
      {:error, reason} ->
        conn
        |> put_flash(:error, "Error creating user")
        |> redirect(to: admin_path(conn, :login))
    end
  end

  def sign_in_user(conn, %{"user" => user}) do
    case Accounts.get_user_by_email(user.email) do
      %User{} = user ->
        auth_user(conn, user)
      nil ->
        conn
        |> put_flash(:error, "Error logging in.")
        |> redirect(to: admin_path(conn, :login))
    end
  end

  def auth_user(conn, %User{} = user) do
    conn
    |> Writing.Guardian.Plug.sign_in(user)
    |> Writing.Guardian.Plug.remember_me(user, %{}, [])
    |> put_flash(:info, "Successfully authenticated.")
    |> redirect(to: admin_path(conn, :index))
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> redirect(to: admin_path(conn, :login))
  end

end
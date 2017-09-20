defmodule Writing.Plugs.IsAdmin do
  use Guardian.Plug.Pipeline, otp_app: :writing

  import Plug.Conn

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug :check_admin

  def check_admin(conn, _) do
    conn
    |> assign(:is_admin, Guardian.Plug.authenticated?(conn, []))
  end

  def auth_error(conn, _, _s) do
    conn
  end
end
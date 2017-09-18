defmodule Writing.Plugs.IsAdmin do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _) do
    conn
    |> assign(:is_admin, Guardian.Plug.authenticated?(conn, []))
  end
end
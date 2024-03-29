defmodule WritingWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import WritingWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint WritingWeb.Endpoint

      # Sign in the user and place the `jwt` token in header
      def guardian_login(%Writing.Accounts.User{} = user), do: guardian_login(conn(), user, :token, [])
      def guardian_login(%Writing.Accounts.User{} = user, token), do: guardian_login(conn(), user, token, [])
      def guardian_login(%Writing.Accounts.User{} = user, token, opts), do: guardian_login(conn(), user, token, opts)

      def guardian_login(%Plug.Conn{} = conn, user), do: guardian_login(conn, user, :token, [])
      def guardian_login(%Plug.Conn{} = conn, user, token), do: guardian_login(conn, user, token, [])
      def guardian_login(%Plug.Conn{} = conn, user, token, opts) do
        conn = conn
        |> Writing.Guardian.Plug.sign_in(user)
        jwt = Writing.Guardian.Plug.current_token(conn)

        conn
        |> assign(:user, user)
        |> assign(:user_id, user.id)
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> Writing.Guardian.Plug.put_current_resource(user)
      end
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Writing.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Writing.Repo, {:shared, self()})
    end
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

end

defmodule WritingWeb.AuthAccessPipelineTest do
  use WritingWeb.ConnCase, async: true

  alias Writing.Accounts

  test "user is redirected when user is not set", %{conn: conn} do
    conn |> WritingWeb.Plugs.AuthAccessPipeline.call(%{})

    IO.inspect conn

    assert redirected_to(conn) == "/login"
  end

  test "user passes through when user authenticated", %{conn: conn} do

  end

end

defmodule CursifWeb.ContextTest do
  use CursifWeb.ConnCase

  import Cursif.AccountsFixtures, only: [authenticated: 1]

  alias CursifWeb.Context

  describe "authorize/1" do
    setup [:authenticated]

    test "successful authorization", %{conn: _conn, token: token} do
      assert {:ok, _claim} = Context.authorize(token)
    end

    test "failing authorization", %{conn: _conn} do
      assert {:error, _reason} = Context.authorize("invalid token")
    end
  end
end
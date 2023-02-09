defmodule Cursif.GuardianTest do
  use CursifWeb.ConnCase
  import Cursif.AccountsFixtures, only: [authenticated: 1, create_unique_user: 1]

  alias Cursif.Guardian

  setup [:authenticated, :create_unique_user]

  describe "subject_for_token/2" do
    test "successful subject id retrieval", %{conn: conn, current_user: current_user} do
      assert {:ok, _id} = Guardian.subject_for_token(current_user, conn)
    end

    test "failing subject id retrieval", %{conn: conn} do
      assert {:error, :no_id_provided} = Guardian.subject_for_token(%{}, conn)
    end
  end

  describe "resource_from_claims/2" do
    test "successful resource retrieval", %{token: token} do
      {:ok, claim} = Guardian.decode_and_verify(token)
      assert {:ok, _} = Guardian.resource_from_claims(claim)
    end

    test "failing resource retrieval", %{conn: _conn} do
      assert {:error, :resource_not_found} = Guardian.resource_from_claims(%{})
    end
  end
end
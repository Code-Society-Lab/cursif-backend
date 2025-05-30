defmodule CursifWeb.Resolvers.AccountsTest do
  use ExUnit.Case, async: true

  use CursifWeb.ConnCase
  import Cursif.AccountsFixtures

  alias CursifWeb.Resolvers.Accounts
  alias Cursif.Notebooks.Page


  setup [:create_unique_user]

  describe "list_users/2" do
    test "list_users/2 successfully list accounts", %{conn: conn} do
      assert {:ok, [_ | _]} = Accounts.list_users(%{}, conn)
    end
  end

  describe "get_user/2" do
    test "successfully fetch specific user id", %{user: user, conn: conn} do
      assert Accounts.get_user_by_id(%{id: user.id}, conn) == {:ok, user}
    end

    test "fetch user with invalid id", %{conn: conn} do
      assert Accounts.get_user_by_id(%{id: "1a2b34c5-6def-78gh-ijkl-m9101112n131"}, conn) == {:error, :user_not_found}
    end
  end

  describe "get_current_user/2" do
    test "successfully fetch current user", %{user: user} do
      assert Accounts.get_current_user(%{}, %{context: %{current_user: user}}) == {:ok, user}
    end
  end

  describe "register/2" do
    test "successful user registration", %{conn: conn} do
      user_attributes = unique_user_attributes()

      case Accounts.register(user_attributes, conn) do
        {:ok, page} ->
          assert %Page{} = page
          assert page.title == "Welcome"
          assert page.content != nil
          assert page.parent_id != nil
          assert page.parent_type == "notebook"
        {:error, _} ->
          flunk("Expected successful registration but got an error")
      end
    end

    test "failing user registration, missing attributes", %{conn: conn} do
      assert {:error, %{errors: errors}} = Accounts.register(%{}, conn)
      assert [username: _, email: _, password: _] = errors
    end

    test "failing user registration, invalid attributes", %{conn: conn, user: user} do
      unique_user = unique_user_attributes()
      assert {:error, %Ecto.Changeset{}} = Accounts.register(%{unique_user | username: user.username}, conn)
      assert {:error, %Ecto.Changeset{}} = Accounts.register(%{unique_user | email: user.email}, conn)
    end
  end

  describe "login/2" do
    test "successful login", %{conn: conn, user: user, password: password} do
      assert {:ok, %{user: _, token: _}} = Accounts.login(%{email: user.email, password: password}, conn)
    end

    test "failing login", %{conn: conn} do
      user = unique_user_attributes()
      assert {:error, :invalid_credentials} = Accounts.login(%{email: user.email, password: user.password}, conn)
    end
  end
end
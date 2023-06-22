defmodule CursifWeb.Resolvers.AccountsTest do
  use CursifWeb.ConnCase
  import Cursif.AccountsFixtures

  alias CursifWeb.Resolvers.Accounts
  alias Cursif.Accounts.User

  setup [:create_unique_user, :authenticated]

  describe "list_users/2" do
    test "list_users/2 successfully list accounts", %{current_user: current_user, user: user} do
      assert Accounts.list_users(%{}, %{context: %{current_user: current_user}}) == {:ok, [user, current_user]}
    end

    test "not authenticated", %{conn: conn} do
      assert Accounts.list_users(%{}, conn) == {:error, :unauthenticated}
    end
  end

  describe "get_user/2" do
    test "successfully fetch specific user id", %{current_user: current_user, user: user} do
      assert Accounts.get_user_by_id(%{id: user.id}, %{context: %{current_user: current_user}}) == {:ok, user}
    end

    test "fetch user with invalid id", %{current_user: current_user} do
      context = %{context: %{current_user: current_user}}
      assert Accounts.get_user_by_id(%{id: "wrong id"}, context) == {:error, :user_not_found}
    end

    test "not authenticated", %{conn: conn} do
      assert Accounts.get_user_by_id(%{}, conn) == {:error, :unauthenticated}
    end
  end

  describe "get_current_user/2" do
    test "successfully fetch current user", %{current_user: current_user} do
      assert Accounts.get_current_user(%{}, %{context: %{current_user: current_user}}) == {:ok, current_user}
    end

    test "not authenticated", %{conn: conn} do
      assert Accounts.get_current_user(%{}, conn) == {:error, :unauthenticated}
    end
  end

  describe "register/2" do
    test "successful user registration", %{conn: conn} do
      assert {:ok, %User{} = _} = Accounts.register(unique_user_attributes(), conn)
    end

    test "failing user registration, missing attributes", %{conn: conn} do
      assert {:error, %{errors: errors}} = Accounts.register(%{}, conn)
      assert [username: _, email: _, password: _] = errors
    end

    test "failing user registration, invalide attributes", %{conn: conn, user: user} do
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
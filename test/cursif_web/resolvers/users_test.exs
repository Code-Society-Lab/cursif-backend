defmodule CursifWeb.Resolvers.UsersTest do
  use CursifWeb.ConnCase
  import Cursif.UsersFixtures

  alias CursifWeb.Resolvers.Users
  alias Cursif.Users.User

  setup [:create_unique_user, :authenticated]

  describe "get_users/2" do
    test "successfully list users", %{current_user: current_user, user: user} do
      assert Users.get_users(%{}, %{context: %{current_user: current_user}}) == {:ok, [user, current_user]}
    end

    test "not authenticated", %{conn: conn} do
      assert Users.get_users(%{}, conn) == {:error, :not_authorized}
    end
  end

  describe "get_user/2" do
    test "successfully fetch specific user id", %{current_user: current_user, user: user} do
      assert Users.get_user(%{id: user.id}, %{context: %{current_user: current_user}}) == {:ok, user}
    end

    test "not authenticated", %{conn: conn} do
      assert Users.get_user(%{}, conn) == {:error, :not_authorized}
    end
  end

  describe "get_current_user/2" do
    test "successfully fetch current user", %{current_user: current_user} do
      assert Users.get_current_user(%{}, %{context: %{current_user: current_user}}) == {:ok, current_user}
    end

    test "not authenticated", %{conn: conn} do
      assert Users.get_current_user(%{}, conn) == {:error, :not_authorized}
    end
  end

  describe "register/2" do
    test "successful user registration", %{conn: conn} do
      unique_user = unique_user_attributes()
      assert {:ok, %User{} = _} = Users.register(unique_user, conn)
    end

    test "failing user registration, missing attributes", %{conn: conn} do
      assert {:error, %{errors: errors}} = Users.register(%{}, conn)
      assert [username: _, email: _, password: _] = errors
    end

    test "failing user registration, invalide attributes", %{conn: conn, user: user} do
      unique_user = unique_user_attributes()
      assert {:error, %Ecto.Changeset{}} = Users.register(%{unique_user | username: user.username}, conn)
    end
  end

  describe "login/2" do
    test "successful login", %{conn: conn, user: user, password: password} do
      assert {:ok, %{user: _, token: _}} = Users.login(%{email: user.email, password: password}, conn)
    end

    test "failing login", %{conn: conn} do

    end
  end
end
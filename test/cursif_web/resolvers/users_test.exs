defmodule CursifWeb.Resolvers.UsersTest do
  use CursifWeb.ConnCase
  import Cursif.UsersFixtures

  alias CursifWeb.Resolvers.Users

  test "get_users/2 returns all users", %{conn: conn} do
    user = user_fixture()
    assert Users.get_users(%{}, conn) == {:ok, [user]}
  end

  test "get_user!/2 returns the user with given id", %{conn: conn} do
    user = user_fixture()
    assert Users.get_user!(%{id: user.id}, conn) == {:ok, user}
  end
end
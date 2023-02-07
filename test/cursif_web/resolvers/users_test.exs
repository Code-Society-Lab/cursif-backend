defmodule CursifWeb.Resolvers.UsersTest do
  use CursifWeb.ConnCase
  import Cursif.UsersFixtures

  alias CursifWeb.Resolvers.Users

  setup [:create_unique_user, :authenticated]

  test "get_users/2 returns all users", %{current_user: current_user, user: user} do
    assert Users.get_users(%{}, %{context: %{current_user: current_user}}) == {:ok, [user, current_user]}
  end

  test "get_user!/2 returns the user with given id", %{current_user: current_user, user: user} do
    assert Users.get_user!(%{id: user.id}, %{context: %{current_user: current_user}}) == {:ok, user}
  end
end
defmodule Forum.AccountsTest do
  use Cursif.DataCase

  alias Cursif.Users

  import Cursif.UsersFixtures
  alias Cursif.Users.{User}
  
  describe "get user by id" do
    test "does not return the user if it doesn't exists" do
      refute Users.get_by_id!("-1")
    end

    test "return the user if exists" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Users.get_by_id!(user.id)
    end
  end
end
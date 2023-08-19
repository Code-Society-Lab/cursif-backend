defmodule Cursif.AccountsTest do
  use Cursif.DataCase

  import Cursif.AccountsFixtures

  alias Cursif.Accounts
  alias Cursif.Accounts.User

  describe "accounts" do
    @invalid_attrs %{
      email: "helloError",
      first_name: nil,
      hashed_password: nil,
      password: "123abc",
      last_name: nil,
      username: "jdoe"
    }

    test "list_users/0 returns all accounts" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        username: "jdoe",
        email: "jdoe@email.com",
        first_name: "John",
        last_name: "Doe",
        password: "HelloWorld!",
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "jdoe@email.com"
      assert user.first_name == "John"
      assert user.last_name == "Doe"
      assert user.username == "jdoe"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{
        username: "jdoe",
        email: "jdoe@email.com",
        first_name: "John",
        last_name: "Doe",
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.email == "jdoe@email.com"
      assert user.first_name == "John"
      assert user.last_name == "Doe"
      assert user.username == "jdoe"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end

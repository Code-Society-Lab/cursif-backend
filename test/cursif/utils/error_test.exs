defmodule Cursif.Utils.ErrorTest do
  use Cursif.DataCase

  alias Cursif.Utils.Error
  alias Cursif.Accounts.User
  alias Cursif.Repo

  describe "regular error handling" do
    test "unknown resource" do
      error = Error.normalize({:error, :unknown_resource})
      assert error == %Error{code: :unknown_resource, message: "Unknown Resource", status_code: 400}
    end

    test "invalid argument" do
      error = Error.normalize({:error, :invalid_argument})
      assert error == %Error{code: :invalid_argument, message: "Invalid arguments passed", status_code: 400}
    end

    test "unauthenticated" do
      error = Error.normalize({:error, :unauthenticated})
      assert error == %Error{code: :unauthenticated, message: "You need to be logged in", status_code: 401}
    end

    test "password hash missing" do
      error = Error.normalize({:error, :password_hash_missing})
      assert error == %Error{code: :password_hash_missing, message: "Reset your password to login", status_code: 401}
    end

    test "invalid credentials" do
      error = Error.normalize({:error, :invalid_credentials})
      assert error == %Error{code: :invalid_credentials, message: "Invalid credentials", status_code: 401}
    end

    test "unauthorized" do
      error = Error.normalize({:error, :unauthorized})
      assert error == %Error{code: :unauthorized, message: "You don't have permission to do this", status_code: 403}
    end

    test "not found" do
      error = Error.normalize({:error, :not_found})
      assert error == %Error{code: :not_found, message: "Resource not found", status_code: 404}
    end

    test "user not found" do
      error = Error.normalize({:error, :user_not_found})
      assert error == %Error{code: :user_not_found, message: "User not found", status_code: 404}
    end

    test "unknown" do
      error = Error.normalize({:error, :unknown})
      assert error == %Error{code: :unknown, message: "Something went wrong", status_code: 500}
    end

    test "unhandled code" do
      error = Error.normalize({:error, :unhandled_code})
      assert error == %Error{code: :unhandled_code, message: "unhandled_code", status_code: 422}
    end
  end

  describe "ecto error handling" do
    test "no results" do
      try do
        Repo.get!(User, "9218062f-fbf6-4235-a58a-2d7681bb13a6")
      rescue e ->
        assert Error.normalize(e) == %Error{code: :unknown, message: "Something went wrong", status_code: 500}
      end
    end

    test "changeset error" do
      changeset = User.changeset(%User{}, %{})
      assert Error.normalize(changeset) == [
               %Error{
                 code: :validation,
                 message: "Email can't be blank",
                 status_code: 422
               },
               %Cursif.Utils.Error{
                 code: :validation,
                 message: "Password can't be blank",
                 status_code: 422
               },
               %Cursif.Utils.Error{
                 code: :validation,
                 message: "Username can't be blank",
                 status_code: 422
               }
             ]
    end

    test "transaction error" do
      attrs = %{username: "Ada", email: "ada@example.ca"}

      {:error, changeset} = %User{}
                            |> User.changeset(%{username: "Ada", email: "ada@example.ca"})
                            |> Repo.insert()

      error = Error.normalize({:error, changeset.action, changeset.errors, changeset.changes})
      assert error == [%Error{code: :unknown, message: "Something went wrong", status_code: 500}]
    end
  end
end
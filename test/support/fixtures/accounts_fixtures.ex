defmodule Cursif.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cursif.Accounts` context.
  """

  alias Cursif.Accounts

  @valid_user_attributes %{
      email: "grace.hopper@example.com",
      password: "AdaLovelace123!",
      first_name: "Grace",
      last_name: "Hopper",
      username: "grace"
    }

  @doc """
  Generates a random unique user
  """
  def unique_user_attributes do
    first_name = "user"
    last_name = "#{System.unique_integer([:positive])}"

    %{
      email: "#{first_name}.#{last_name}@example.com",
      username: "u#{last_name}",
      password: "AdaLovelace123!",
      first_name: first_name,
      last_name: last_name
    }
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_user_attributes)
      |> Cursif.Accounts.create_user()

    user
  end

  @doc """
  Callback to creates a unique user before a test is executed.
  """
  def create_unique_user do
    user_attrs = unique_user_attributes()
    {:ok, user} = Accounts.create_user(user_attrs)
    {:ok, user: user, password: user_attrs.password}
  end

  @doc """
  Callback to authenticate a user before a test is executed.

  # Example
    setup [:authenticate]
    test "require authentication" %{conn: conn, user: user, token: token} do
      ...
    end

    setup [:authenticate]
    @tag user_attr user_attribute_map
    test "require authentication from tag" %{conn: conn, user: user, token: token} do
      ...
    end

    setup [:authenticate]
    test "require raw authentication" %{conn: conn, user: user, token: token, password: password} do
      ...
    end
  """
  def authenticate(%{authenticated: true}) do
    {:ok, user: user, password: password} = create_unique_user()
    {:ok, current_user, token} = Accounts.authenticate_user(user.email, password)
    {:ok, current_user: current_user, token: token, current_user_password: password}
  end

  def authenticate(_),
      do: :ok
end

defmodule Cursif.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cursif.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "grace.hopper@email.com",
        first_name: "Grace",
        last_name: "Hopper",
        hashed_password: "**redacted**",
        password: "Hello!worlD",
        username: "grace"
      })
      |> Cursif.Users.create_user()

    user
  end
end

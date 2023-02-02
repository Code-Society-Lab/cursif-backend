defmodule CursifWeb.Resolvers.Users do
  @moduledoc """
  The user resolver
  """

  alias Cursif.Users
  alias Cursif.Guardian
  alias Cursif.Users.User

  @doc """
  Returns the list of users.
  """
  @spec get_users(map(), map()) :: {:ok, list(User.t())}
  def get_users(_args, _context) do
    {:ok, Users.list_users()}
  end

  @doc """
  Returns a user.
  """
  @spec get_user!(map(), map()) :: {:ok, User.t()}
  def get_user!(%{id: id}, _context) do
    {:ok, Users.get_user!(id)}
  end

  # TODO: ADD DOC
  def register(_parent, args, _context) do
    Users.create_user(args)
  end

  # TODO: ADD DOC
  def login(%{email: email, password: password}, _info) do
    case Users.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, %{})
        {:ok, %{user: user, token: jwt}}
      {:error, :invalid_credentials} ->
        {:error, "Incorrect email or password"}
    end
  end
end

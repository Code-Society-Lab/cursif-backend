defmodule CursifWeb.Resolvers.Users do
  @moduledoc """
  The user resolver
  """

  alias Cursif.Users
  alias Cursif.Users.User

  @doc """
  Returns the list of users.
  """
  @spec get_users(map(), %{context: %{current_user: User.t()}}) :: {:ok, list(User.t())}
  def get_users(_args, %{context: %{current_user: _user}}) do
    {:ok, Users.list_users()}
  end

  def get_users(_args, _context), do: {:error, :not_authorized}

  @doc """
  Returns a user.
  """
  @spec get_user!(map(), %{context: %{current_user: User.t()}}) :: {:ok, User.t()}
  def get_user!(%{id: id}, %{context: %{current_user: _user}}) do
    {:ok, Users.get_user!(id)}
  end

  def get_user!(_args, _context), do: {:error, :not_authorized}

  # TODO: ADD DOC
  def register(_parent, args, _context) do
    Users.create_user(args)
  end

  # TODO: ADD DOC
  def login(%{email: email, password: password}, _info) do
    case Users.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Cursif.Guardian.encode_and_sign(user, %{})
        Users.create_user_token(%{user: user, token: jwt})
        {:ok, %{user: user, token: jwt}}
      {:error, :invalid_credentials} ->
        {:error, "Incorrect email or password"}
    end
  end
end

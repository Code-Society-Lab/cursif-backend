defmodule CursifWeb.Resolvers.Users do
  @moduledoc """
  The user resolver
  """

  import CursifWeb.GraphqlHelpers, only: [translate_ecto_error: 1]

  alias Cursif.Users
  alias Cursif.Users.User

  @doc """
  Returns the list of users.
  """
  @spec get_users(map(), %{context: %{current_user: User.t()}}) :: {:ok, list(User.t())}
  def get_users(_args, %{context: %{current_user: _current_user}}) do
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
  @spec get_me!(map(), %{context: %{current_user: User.t()}}) :: {:ok, User.t()}
  def get_me!(_args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def get_me!(_args, _context), do: {:error, :not_authorized}

  # TODO: ADD DOC
  @spec register(map(), map(), map()) :: {:ok, User.t()} | {:error, list(map())}
  def register(_parent, args, _context) do
    case Users.create_user(args) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} ->
        {:error, translate_ecto_error(changeset)}
    end
  end

  # TODO: ADD DOC
  @spec login(%{email: String.t(), password: String.t()}, map()) :: {:ok, User.t()} | {:error, list(map())}
  def login(%{email: email, password: password}, _info) do
    case Users.authenticate_user(email, password) do
      {:ok, user} -> create_token(user)
      {:error, _} -> {:error, "User could not be authenticated."}
    end
  end

  defp create_token(user) do
    case Cursif.Guardian.encode_and_sign(user, %{}) do
      nil -> {:error, "An Error occured creating the token"}
      {:ok, token, _full_claims} -> {:ok, %{token: token}}
    end
  end
end
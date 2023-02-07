defmodule CursifWeb.Resolvers.Users do
  @moduledoc false

  alias Cursif.Users
  alias Cursif.Users.User

  @spec get_users(map(), %{context: %{current_user: User.t()}}) :: {:ok, list(User.t())}
  def get_users(_args, %{context: %{current_user: _current_user}}) do
    {:ok, Users.list_users()}
  end
  def get_users(_args, _context), do: {:error, :not_authorized}

  @spec get_user!(map(), %{context: %{current_user: User.t()}}) :: {:ok, User.t()}
  def get_user!(%{id: id}, %{context: %{current_user: _user}}) do
    {:ok, Users.get_user!(id)}
  end
  def get_user!(_args, _context), do: {:error, :not_authorized}

  @spec get_me!(map(), %{context: %{current_user: User.t()}}) :: {:ok, User.t()}
  def get_me!(_args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def get_me!(_args, _context), do: {:error, :not_authorized}

  @spec register(map(), map(), map()) :: {:ok, User.t()} | {:error, list(map())}
  def register(_parent, args, _context) do
    case Users.create_user(args) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec login(%{email: String.t(), password: String.t()}, map()) :: {:ok, User.t()} | {:error, list(map())}
  def login(%{email: email, password: password}, _info) do
    case Users.authenticate_user(email, password) do
      {:ok, user, token} -> {:ok, %{user: user, token: token}}
      {:error, _} -> {:error, :invalid_credentials}
    end
  end
end
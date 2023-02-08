defmodule CursifWeb.Resolvers.Accounts do
  alias Cursif.Accounts
  alias Cursif.Accounts.User

  @doc """
  Resolve a list accounts
  """
  @spec list_users(map(), %{context: %{current_user: User.t()}}) :: {:ok, list(User.t())}
  def list_users(_args, %{context: %{current_user: _current_user}}) do
    {:ok, Accounts.list_users()}
  end
  def list_users(_args, _context), do: {:error, :not_authorized}

  @doc """
  Resolve a specific user.

  Only a limited number of information is visible.
  """
  @spec get_user_by_id(map(), %{context: %{current_user: User.t()}}) :: {:ok, User.t()}
  def get_user_by_id(%{id: id}, %{context: %{current_user: _user}}) do
    {:ok, Accounts.get_user!(id)}
  end
  def get_user_by_id(_args, _context), do: {:error, :not_authorized}

  @doc """
  Resolve the current user
  """
  @spec get_current_user(map(), %{context: %{current_user: User.t()}}) :: {:ok, User.t()}
  def get_current_user(_args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end
  def get_current_user(_args, _context), do: {:error, :not_authorized}

  @doc """
  Resolve the current user
  """
  @spec register(map(), map()) :: {:ok, User.t()} | {:error, list(map())}
  def register(args, _context) do
    case Accounts.create_user(args) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @spec login(%{email: String.t(), password: String.t()}, map()) :: {:ok, User.t()} | {:error, list(map())}
  def login(%{email: email, password: password}, _context) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user, token} -> {:ok, %{user: user, token: token}}
      {:error, _} -> {:error, :invalid_credentials}
    end
  end
end
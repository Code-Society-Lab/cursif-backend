defmodule CursifWeb.Resolvers.Accounts do
  alias Cursif.Accounts
  alias Cursif.Accounts.User

  @spec get_current_user(map(), %{context: %{current_user: User.t()}}) :: {:ok, User.t()}
  def get_current_user(_args, %{context: %{current_user: current_user}}),
    do: {:ok, current_user}

  def get_current_user(_, _),
    do: {:error, :unauthenticated}


  @spec register(map(), map()) :: {:ok, User.t()} | {:error, list(map())}
  def register(args, _context) do
    case Accounts.create_user(args) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @spec update_user(map(), map()) :: {:ok, User.t()} | {:error, atom()}
  def update_user(%{id: id} = args, _context) do
    user = Accounts.get_user!(id)
    case Accounts.update_user(user, args) do
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
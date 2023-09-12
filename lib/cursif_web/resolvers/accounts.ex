defmodule CursifWeb.Resolvers.Accounts do
  alias Cursif.Accounts
  alias Cursif.Accounts.User

  @spec list_users(map(), map()) :: {:ok, list(User.t())}
  def list_users(_args, _context) do
    {:ok, Accounts.list_users()}
  end

  @spec get_user_by_id(map(), map()) :: {:ok, User.t()} | {:error, atom()}
  def get_user_by_id(%{id: id}, _context) do
    {:ok, Accounts.get_user!(id)}
  rescue _ ->
    {:error, :user_not_found}
  end

  @spec get_current_user(map(), %{context: %{current_user: User.t()}}) :: {:ok, User.t()}
  def get_current_user(_args, %{context: %{current_user: current_user}}),
    do: {:ok, current_user}

  def get_current_user(_, _),
    do: {:error, :unauthenticated}

  @spec register(map(), map()) :: {:ok, User.t()} | {:error, list(map())}
  def register(args, _context) do
    case Accounts.create_user(args) do
      {:ok, user} ->
        {:ok, _} = Accounts.verify_user(user)
        {:ok, user}

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
      {:error, :invalid_credentials} -> {:error, :invalid_credentials}
      {:error, :not_confirmed} -> {:error, :not_confirmed}
    end
  end

  @doc """
  Confirm a user's account.
  """
  @spec confirm(map()) :: {:ok, User.t()} | {:error, atom()}
  def confirm(%{"token" => token}) do
    user = Accounts.get_user_by_confirmation_token(token)

    case user do
      {:ok, user} ->
        case user.confirmed_at do
          nil ->
            case User.confirm_email(user) do
              {:ok, _user} -> {:ok, %{message: "Account confirmed successfully"}}

              {:error, _changeset} -> {:error, %{message: "Failed to confirm account"}}
            end

          _ ->  {:errpr, :already_confirmed}
        end

      {:error, _} -> {:error, :invalid_token}
    end
  end
end
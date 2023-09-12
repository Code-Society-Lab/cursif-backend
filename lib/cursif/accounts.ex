defmodule Cursif.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Cursif.Repo

  alias Cursif.Accounts.User
  alias CursifWeb.Emails.UserEmail
  alias Argon2

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  @spec list_users :: list(User.t())
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_user!(binary()) :: User.t()
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  @spec create_user(map()) :: {:ok, User.t()} | {:error, %Ecto.Changeset{}}
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_user(User.t(), map()) :: {:ok, User.t()} | {:error, %Ecto.Changeset{}}
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_user(User.t()) :: {:ok, User.t()} | {:error, %Ecto.Changeset{}}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user(User.t(), map()) ::  %Ecto.Changeset{data: User.t()}
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Authenticates a user by its username and password

  ## Examples

      iex> authenticate_user("ghopper@example.com", "GraceHopper1234")
      {:ok, %User{}}

      iex> authenticate_user("ghopper@example.com", "BadPassword")
      {:error, :invalid_credentials}
  """
  @spec authenticate_user(String.t(), String.t()) :: {:ok, User.t(), String.t()} | {:error, :invalid_credentials | :not_confirmed}
  def authenticate_user(email, plain_text_password) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :invalid_credentials}
      user ->
        if is_nil(user.confirmed_at) do
          {:error, :not_confirmed}
        else
          case Argon2.verify_pass(plain_text_password, user.hashed_password) do
            true ->
              {:ok, user, create_token(user)}
            false ->
              {:error, :invalid_credentials}
          end
        end
    end
  end

  @doc """
  Creates a token for a user with Guardian and Phoenix.Token
  """
  @spec create_token(User.t()) :: {:ok, String.t(), map()} | {:error, String.t()}
  def create_token(user, stategy \\ :guardian)

  def create_token(user, :guardian) do
    case Cursif.Guardian.encode_and_sign(user, %{}) do
      {:ok, token, _full_claims} -> token
    end
  end

  def create_token(user, :phoenix_token) do
    {:ok, Phoenix.Token.sign(CursifWeb.Endpoint, "user id", user.id)}
  end

  @doc """
  Generates a confirmation token.

  ## Examples

      iex> send_confirmation_email(user)
      {:ok, %User{}}

      iex> send_confirmation_email(user)
      {:error, :already_confirmed}
  """
  def send_confirmation_email(%User{} = user) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {:ok, token} = create_token(user, :phoenix_token)
      
      UserEmail.send_confirmation_email(user, token)
    end
  end

  @doc """
  Confirms a user by its confirmation token

  ## Examples

      iex> confirm_user("token")
      {:ok, %User{}}

      iex> confirm_user("bad_token")
      {:error, :user_not_found}
  """
  @spec get_user_by_confirmation_token(String.t()) :: {:ok, User.t()} | {:error, atom()}
  def get_user_by_confirmation_token(token) do
    case Phoenix.Token.verify(CursifWeb.Endpoint, "user id", token, max_age: 300) do
      {:ok, id} -> {:ok, get_user!(id)}
      {:error, :expired} -> {:error, :expired}
    end
  end
end

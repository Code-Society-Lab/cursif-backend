defmodule Cursif.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Cursif.Repo

  alias Cursif.Accounts.User
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
  @spec authenticate_user(String.t(), String.t()) :: {:ok, User.t(), String.t()} | {:error, :invalid_credentials}
  def authenticate_user(email, plain_text_password) do
    case Repo.get_by(User, email: email) do
      nil ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}
      user ->
        if Argon2.verify_pass(plain_text_password, user.hashed_password) do
          {:ok, user, Cursif.Token.generate(user, :session)}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end

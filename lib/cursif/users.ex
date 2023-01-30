defmodule Cursif.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Cursif.Repo

  alias Cursif.Users.{User}

  @doc """
  Gets a single user by it's id.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_by_id!(123)
      %User{}

      iex> get_by_id!(456)
      ** (Ecto.NoResultsError)
  """
  @spec get_by_id!(binary()) :: User.t()
  def get_by_id!(id), do: Repo.get!(User, id)

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  @spec register_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def register_user(params) do
    %User{}
    |> User.registration_changeset(params)
    |> Repo.insert()
  end
end

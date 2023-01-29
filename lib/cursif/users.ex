defmodule Cursif.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Cursif.Repo

  alias Cursif.Users.{User}

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_by_id!(123)
      %User{}

      iex> get_by_id!(456)
      ** (Ecto.NoResultsError)
  """
  @spec get_by_id!(binary()) :: User.t()
  def get_by_id!(id), do: Repo.get!(User, id)
end

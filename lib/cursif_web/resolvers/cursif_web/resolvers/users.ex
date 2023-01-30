defmodule CursifWeb.Resolvers.Users do
  @moduledoc """
  The user resolver
  """

  alias Cursif.Users

  @doc """
  Returns the list of users.
  """
  @spec get_users(map(), map()) :: {:ok, list(User.t())}
  def get_users(_args, _context) do
    {:ok, Users.list_users()}
  end

  @spec get_user!(map(), map()) :: {:ok, User.t()}
  def get_user!(%{id: id}, _context) do
    {:ok, Users.get_user!(id)}
  end
end

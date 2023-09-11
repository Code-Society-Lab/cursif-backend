defmodule Cursif.Token do
  @moduledoc """
  Cursif.Token provides functionality for handling tokens based on specified actions while
  remaining agnostic to the token provider. It offers methods for generating tokens and
  extracting resources from tokens for different actions.

  To use this module, follow the provided function signatures and specify the appropriate action
  and data when calling the functions.

  ### Example
    iex> token = Cursif.Token.generate(%{id: "1234"}, :session)
    iex> Cursif.Token.resource_from_token(token, :session)
    iex> {:ok, %{id: "1234"}}

  To define a new action, add a new function definition for `generate/2` and `resource_from_token/2`
  with the appropriate action atom. Use the token provider of your choice to generate and
  claim tokens.
  """

  alias Cursif.Accounts

  @session_salt "cursif_user_session"
  @confirmation_salt "cursif_user_confirmation"

  @spec generate(map(), atom()) :: String.t()
  def generate(%{id: id}, :session),
    do: Phoenix.Token.encrypt(CursifWeb.Endpoint, @session_salt, id)

  def generate(%{id: id}, :verification),
    do: Phoenix.Token.encrypt(CursifWeb.Endpoint, @confirmation_salt, id)

  def generate(_data, _action),
    do: nil

  @spec resource_from_token(String.t(), atom()) :: {:ok, map()} | {:error, String.t()}
  def resource_from_token(token, :session),
    do: user_from_token(token, @session_salt, max_age: 24 * 60 * 60)

  def resource_from_token(token, :confirmation),
    do: user_from_token(token, @confirmation_salt, max_age: 15 * 60)

  defp user_from_token(token, salt, opts) do
    case Phoenix.Token.decrypt(CursifWeb.Endpoint, salt, token, opts) do
      {:ok, id} when is_binary(id) -> {:ok, Accounts.get_user!(id)}
      _ -> {:error, :user_not_found}
    end
  rescue
    Ecto.NoResultsError -> {:error, :user_not_found}
  end
end
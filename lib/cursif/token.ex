defmodule Cursif.Token do
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
    do: user_from_token(token, @session_salt, 30 * 60 * 60)

  def resource_from_token(token, :confirmation),
    do: user_from_token(token, @confirmation_salt, 15 * 60)

  defp user_from_token(token, salt, max_age) do
    case Phoenix.Token.decrypt(CursifWeb.Endpoint, salt, token, max_age: max_age) do
      {:ok, id} when is_binary(id) -> {:ok, Accounts.get_user!(id)}
      _ -> {:error, :user_not_found}
    end
  rescue
    Ecto.NoResultsError -> {:error, :user_not_found}
  end
end
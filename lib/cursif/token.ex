defmodule Cursif.Token do
  alias Cursif.Accounts

  @session_salt "cursif_user_session"
  @confirmation_salt "cursif_user_confirmation"


  @spec generate(map(), atom()) :: String.t()
  def generate(%{id: id}, :session),
    do: Phoenix.Token.encrypt(CursifWeb.Endpoint, @session_salt, id)

  def generate(%{id: id}, :verification),
    do: Phoenix.Token.encrypt(CursifWeb.Endpoint, @user_confirmation_salt, id)

  def generate(_data, _action),
    do: nil

  @spec verify(String.t(), atom()) :: {:ok, map()} | {:error, String.t()}
  def verify(token, :session),
    do: resource_from_token(token, @session_salt, 30 * 60 * 60, &Accounts.get_user!/1)

  def verify(token, :confirmation),
    do: resource_from_token(token, @confirmation_salt, 15 * 60, &Accounts.get_user!/1)

  defp resource_from_token(token, salt, max_age, resource_function) do
    case Phoenix.Token.decrypt(CursifWeb.Endpoint, salt, token, max_age: max_age) do
      {:ok, id} when is_binary(id) -> {:ok, resource_function.(id)}
      _ -> {:error, :resource_not_found}
    end
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
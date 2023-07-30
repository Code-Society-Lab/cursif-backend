defmodule Cursif.Guardian do
  use Guardian, otp_app: :cursif

  alias Cursif.Accounts
  alias Cursif.Accounts.User

  @doc """
  Retrieves the subject's id from the authentication token.
  """
  @spec subject_for_token(User.t(), map()) :: {:ok, String.t()} | {:error, :no_id_provided}
  def subject_for_token(%{id: id}, _claims) do
    {:ok, to_string(id)}
  end
  def subject_for_token(_, _), do: {:error, :no_id_provided}

  @doc """
   We look up our resource from the claims, the subject can be
   found in the `"sub"` key. In above `subject_for_token/2` we returned
   the resource id so here we'll rely on that to look it up.
  """
  @spec resource_from_claims(%{sub: binary()}) ::  {:ok, User.t()} | {:error, :resource_not_found}
  def resource_from_claims(%{"sub" => id}) do

    {:ok,  Accounts.get_user!(id)}
  end
  def resource_from_claims(_claims), do: {:error, :resource_not_found}
end
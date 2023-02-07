defmodule Cursif.Guardian do
  use Guardian, otp_app: :cursif

  alias Cursif.Users

  @spec subject_for_token(User.t(), map()) :: {:ok, String.t()}
  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  @spec resource_from_claims(%{sub: binary()}) ::  {:ok, User.t()} | {:error, :resource_not_found}
  def resource_from_claims(%{"sub" => id}) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In above `subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    resource = Users.get_user!(id)
    {:ok,  resource}
  end
  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
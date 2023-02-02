defmodule Cursif.Users.Guardian do
  use Guardian, otp_app: :cursif

  alias Cursif.Users

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    {:ok, Users.get_user!(id)}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
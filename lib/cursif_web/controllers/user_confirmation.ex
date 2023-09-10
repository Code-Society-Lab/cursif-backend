defmodule CursifWeb.Controllers.UserConfirmation do
  use CursifWeb, :controller

  alias Cursif.Repo
  alias Cursif.Accounts
  alias Cursif.Accounts.User

  @doc """
  Confirm a user's account.
  """
  def confirm(conn, %{"token" => token}) do
    user = Accounts.get_user_by_confirmation_token(token)

    case user do
      {:ok, user} ->
        case user.confirmed_at do
          nil ->
            changeset = User.confirm_changeset(user)

            case Repo.update(changeset) do
              {:ok, _updated_user} ->
                json(conn, %{status: "success", message: "Account confirmed successfully"})

              {:error, _changeset} ->
                json(conn, %{status: "error", message: "Failed to confirm account"})
            end

          _ ->
            json(conn, %{status: "error", message: "Account already confirmed"})
        end

      {:error, _} ->
        json(conn, %{status: "error", message: "Invalid confirmation token"})
    end
  end
end

defmodule CursifWeb.Resolvers.UserConfirm do
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
        changeset = User.confirm_changeset(user)

        case Repo.update(changeset) do
          {:ok, _updated_user} ->
            conn
            |> put_flash(:info, "Account confirmed successfully")
            |> redirect(to: "/")

          {:error, changeset} ->
            conn
            |> put_flash(:error, "Failed to confirm account")
            |> redirect(to: "/")
        end

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid confirmation token")
        |> redirect(to: "/")
    end
  end
end

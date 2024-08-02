defmodule CursifWeb.Resolvers.Accounts do
  alias Cursif.{Accounts, Notebooks, Pages}
  alias Cursif.Accounts.User

  @spec list_users(map(), map()) :: {:ok, list(User.t())}
  def list_users(_args, _context) do
    {:ok, Accounts.list_users()}
  end

  @spec get_user_by_id(map(), map()) :: {:ok, User.t()} | {:error, atom()}
  def get_user_by_id(%{id: id}, _context) do
    {:ok, Accounts.get_user!(id)}
  rescue _ ->
    {:error, :user_not_found}
  end

  @spec get_current_user(map(), %{context: %{current_user: User.t()}}) :: {:ok, User.t()}
  def get_current_user(_args, %{context: %{current_user: current_user}}),
    do: {:ok, current_user}

  def get_current_user(_, _),
    do: {:error, :unauthenticated}

  defp read_template_content do
    case File.read("priv/templates/welcome.md") do
      {:ok, content} -> content
      {:error, reason} -> "Failed to load template: #{reason}"
    end
  end

  @doc """
  Register a new user and create a template notebook and page for them.
  """
  @spec register(map(), map()) :: {:ok, {User.t(), Notebook.t(), Page.t()}} | {:error, list(map())}
  def register(args, _context) do
    case Accounts.create_user(args) do
      {:ok, user} ->
        case Accounts.verify_user(user) do
          {:ok, _} ->
            template_notebook = %{
              title: "Cursif Introduction",
              description: "Welcome new Cursif user!",
              owner_type: "user",
              owner_id: user.id,
            }
            case Notebooks.create_notebook(template_notebook) do
              {:ok, notebook} ->
                template_page = %{
                  title: "Welcome",
                  content: read_template_content(),
                  parent_id: notebook.id,
                  parent_type: "notebook"
                }
                case Pages.create_page(Map.merge(template_page, %{author_id: user.id})) do
                  {:ok, page} -> {:ok, page}
                  {:error, changeset} -> {:error, changeset}
                end
              {:error, notebook_changeset} -> {:error, notebook_changeset}
            end
          {:error, _} -> {:error, "User verification failed"}
        end
      {:error, changeset} -> {:error, changeset}
    end
  end

  @spec update_user(map(), map()) :: {:ok, User.t()} | {:error, atom()}
  def update_user(%{id: id} = args, _context) do
    user = Accounts.get_user!(id)
    case Accounts.update_user(user, args) do
        {:ok, user} -> {:ok, user}
        {:error, changeset} -> {:error, changeset}
    end
  end

  @spec login(%{email: String.t(), password: String.t()}, map()) :: {:ok, User.t()} | {:error, list(map())}
  def login(%{email: email, password: password}, _context) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user, token} -> {:ok, %{user: user, token: token}}
      {:error, :invalid_credentials} -> {:error, :invalid_credentials}
      {:error, :not_confirmed} -> {:error, :not_confirmed}
    end
  end

  @doc """
  Confirm a user's account.
  """
  @spec confirm(map(), map()) :: {:ok, User.t()} | {:error, atom()}
  def confirm(%{token: token}, _context) do
    user = Accounts.get_user_by_confirmation_token(token)

    case user do
      {:ok, user} ->
        case user.confirmed_at do
          nil ->
            case User.confirm_email(user) do
              {:ok, _user} -> {:ok, "Account confirmed successfully"}

              {:error, _changeset} -> {:error, "Failed to confirm account"}
            end

          _ ->  {:error, :already_confirmed}
        end

      {:error, _} -> {:error, :invalid_token}
    end
  end

  @doc """
  Resend a confirmation email to a user.
  """
  @spec resend_confirmation_email(map(), map()) :: {:ok, User.t()} | {:error, atom()}
  def resend_confirmation_email(%{email: email}, _context) do
    user = Accounts.get_user_by_email!(email)

    case Accounts.verify_user(user) do
      {:ok, _user} -> {:ok, "Confirmation email sent successfully"}
      {:error, error} -> {:error, error}
    end
  rescue Ecto.NoResultsError ->
    {:error, "No users registered with this email"}
  end

  @doc """
  Send a password reset email to a user.
  """
  @spec send_reset_password_token(map(), map()) :: {:ok, User.t()} | {:error, atom()}
  def send_reset_password_token(%{email: email}, _context) do
    user = Accounts.get_user_by_email!(email)

    case Accounts.send_new_password(user) do
      {:ok, _} -> {:ok, "Password reset email sent successfully"}
      {:error, error} -> {:error, error}
    end
  rescue Ecto.NoResultsError ->
    {:error, "This email is not associated with any account"}
  end

  @doc """
  Reset a user's password.
  """
  @spec reset_password(map(), map()) :: {:ok, User.t()} | {:error, atom()}
  def reset_password(%{password: _password, token: token} = args, _context) do
    user = Accounts.get_user_by_confirmation_token(token)

    case user do
      {:ok, user} ->
        case Accounts.reset_password(user, args) do
          {:ok, _user} -> {:ok, "Password reset successfully!"}
          {:error, changeset} -> {:error, changeset}
        end

      {:error, _} -> {:error, :invalid_token}
    end
  end
end
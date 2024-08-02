defmodule CursifWeb.Emails.UserEmail do
  use Phoenix.Swoosh, 
    view: CursifWeb.EmailView, 
    layout: {CursifWeb.LayoutView, :email}

  import Swoosh.Email
  alias Cursif.Mailer

  @client_url Application.compile_env(:cursif, :client_url)
  @client_email Application.compile_env(:cursif, :email_sender)

  defp send_email(user, subject, base_url, context, extra_context \\ %{}) do
    email_context = Map.merge(%{username: user.username, base_url: base_url}, extra_context)
    
    email =
      new()
      |> from({"Cursif", @client_email})
      |> to(user.email)
      |> subject(subject)
      |> render_body(context, email_context)
    
    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Sends a confirmation email to a user.
  """
  def send_confirmation_email(user, token) do
    base_url = "#{@client_url}/confirm?token=#{token}"
    send_email(user, "Welcome to Cursif ~ Email Verification", base_url, "welcome.html", %{token: token})
  end

  @doc """
  Sends a password reset email to a user.
  """
  def send_password_reset_email(user, token) do
    base_url = "#{@client_url}/reset-password?token=#{token}"
    send_email(user, "Cursif ~ Password Reset", base_url, "reset.html", %{token: token})
  end

  @doc """
  Sends a collaboration invitation email to a user.
  """
  def send_collaborator_email(user, notebook, owner) do
    base_url = "#{@client_url}/notebooks/#{notebook}"
    send_email(user, "Cursif ~ Collaboration Notification", base_url, "add.html", %{owner: owner})
  end
end

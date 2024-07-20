defmodule CursifWeb.Emails.UserEmail do
  use Phoenix.Swoosh, 
    view: CursifWeb.EmailView, 
    layout: {CursifWeb.LayoutView, :email}

  import Swoosh.Email
  alias Cursif.Mailer

  @client_url Application.compile_env(:cursif, :client_url)
  @client_email Application.compile_env(:cursif, :email_sender)

  defp send_email(user, subject, base_url, context) do
    email =
      new()
      |> from({"Cursif", @client_email})
      |> to(user.email)
      |> subject(subject)
      |> render_body(context, %{username: user.username, base_url: base_url})
    
    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Sends a confirmation email to a user.
  """
  def send_confirmation_email(user, token) do
    base_url = "#{@client_url}/confirm?token=#{token}"
    send_email(user, "Welcome to Cursif ~ Email Verification", base_url, "welcome.html")
  end

  @doc """
  Sends a password reset email to a user.
  """
  def send_password_reset_email(user, token) do
    base_url = "#{@client_url}/reset-password?token=#{token}"
    send_email(user, "Cursif ~ Password Reset", base_url, "reset.html")
  end

  @doc """
  Sends a collaboration invitation email to a user.
  """
  def send_collaborator_invitation_email(user, notebook) do
    base_url = "#{@client_url}/notebooks/#{notebook}"
    send_email(user, "Cursif ~ Collaboration Invitation", base_url, "invite.html")
  end
end

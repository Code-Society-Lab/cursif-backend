defmodule CursifWeb.Emails.UserEmail do
  use Phoenix.Swoosh, 
    view: CursifWeb.EmailView, 
    layout: {CursifWeb.LayoutView, :email}

  import Swoosh.Email
  alias Cursif.Mailer

  defp send_email(user, subject, base_url, context) do
    email =
      new()
      |> from({"Cursif", "cursif@codesociety.xyz"})
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
    client_url = Application.get_env(:cursif, :client_url)
    base_url = "#{client_url}/confirm?token=#{token}"
    send_email(user, "Welcome to Cursif ~ Email Verification", base_url, "welcome.html")
  end

  @doc """
  Sends a password reset email to a user.
  """
  def send_password_reset_email(user, token) do
    client_url = Application.get_env(:cursif, :client_url)
    base_url = "#{client_url}/reset-password?token=#{token}"
    send_email(user, "Cursif ~ Password Reset", base_url, "reset.html")
  end
end

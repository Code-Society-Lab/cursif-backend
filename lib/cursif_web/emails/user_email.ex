defmodule CursifWeb.Emails.UserEmail do
  use Phoenix.Swoosh, 
    view: CursifWeb.EmailView, 
    layout: {CursifWeb.LayoutView, :email}

  import Swoosh.Email
  alias Cursif.Mailer

  defp send_email(user, subject, base_url) do
    email =
      new()
      |> from({"Cursif", Application.get_env(:cursif, :email_from)})
      |> to(user.email)
      |> subject(subject)
      |> render_body("welcome.html", %{username: user.username, base_url: base_url})
    
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
    send_email(user, "Welcome to Cursif ~ Email Verification", base_url)
  end
end

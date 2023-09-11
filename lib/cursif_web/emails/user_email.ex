defmodule CursifWeb.Emails.UserEmail do
  use Phoenix.Swoosh, 
    view: CursifWeb.EmailView, 
    layout: {CursifWeb.LayoutView, :email}

  import Swoosh.Email
  alias Cursif.Mailer

  defp send_email(user, subject, base_url) do
    email =
      new()
      |> from({"Cursif", "cursif@codesociety.xyz"})
      |> to(user.email)
      |> subject(subject)
      |> render_body("welcome.html", %{username: user.username, base_url: base_url})
    
    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def send_confirmation_email(user, token) do
    base_url = "#{CursifWeb.Endpoint.url()}/users/confirm?token=#{token}"
    send_email(user, "Welcome to Cursif ~ Email Verification", base_url)
  end
end
defmodule Cursif.Accounts.UserNotifier do
  import Swoosh.Email
  alias Cursif.Mailer

  defp welcome_email(recipient, subject, body) do
    email =
      new()
      |> from({"Cursif", "cursif@codesociety.xyz"})
      |> to(recipient)
      |> subject(subject)
      |> text_body(body)
    
    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    welcome_email(user.email, "Welcome to Cursif ~ Email Verification", """
    ------------------------------
    Hi #{user.username},

    Welcome to Cursif!
    
    You can confirm your account by visiting the URL below:

    #{url}

    If you did not create an account with us, please ignore this.
    ------------------------------
    """)
  end
end

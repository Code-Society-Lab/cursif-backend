defmodule Cursif.Accounts.UserNotifier do
  import Swoosh.Email
  alias Cursif.Mailer

  def welcome_email() do
    email =
    new()
    |> from("test@gmail.com")
    |> to("test@gmail.com")
    |> subject("Welcome to Cursif!")
    |> text_body("Welcome!")
    
    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end
end

defmodule Cursif.Accounts.UserNotifier do
  import Bamboo.Email
  alias Cursif.Mailer
  
  def welcome_email(user) do
    email =
    new_email()
    |> from("christopher_dedm3957@elcamino.edu")
    |> to(user.email)
    |> subject("Welcome to Cursif!")
    |> text_body("Welcome, #{user.username}!")
    
    with {:ok, _metadata} <- Mailer.deliver_now(email) do
      {:ok, email}
    end
  end
end

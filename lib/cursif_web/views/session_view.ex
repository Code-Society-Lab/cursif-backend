defmodule CursifWeb.SessionView do
  use CursifWeb, :view

  def render("authenticated.json", %{user: user, jwt: jwt}) do
    %{
      status: :ok,
      data: %{
        token: jwt,
        email: user.email
      },
      message: "You are successfully logged in! Add this token to authorization header to make authorized requests."
    }
  end

  def render("authentication_error.json", %{message: message}) do
    %{
      status: :not_found,
      data: %{},
      message: message
    }
  end

  def render("registration.json", %{user: user, jwt: jwt}) do
    %{
      status: :ok,
      data: %{
        token: jwt,
        email: email.user
      },
      message: "Registration successful"
    }
  end

  def render("registration_error.json", %{message: message}) do
    %{
      status: :registration_failed,
      data: %{},
      message: message
    }
  end
end
defmodule CursifWeb.SessionController do
  use CursifWeb, :controller

  alias Cursif.Users
  alias Cursif.Users.Guardian

  action_fallback CursifWeb.FallbackController

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Users.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, %{})
        render(conn, "authenticated.json", user: user, jwt: jwt)
      {:error, :invalid_credentials} ->
        conn
        |> put_status(401)
        |> render("authentication_error.json", message: "User could not be authenticated")
    end
  end

  def register(conn, %{"user" => user}) do
    Users.create_user(user)
    case Repo.insert(changeset) do
      {:ok, user} ->
        { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)
        conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> json(%{access_token: jwt}) # Return token to the client
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render("registration_error.json", "422.json-api")
    end
  end
end
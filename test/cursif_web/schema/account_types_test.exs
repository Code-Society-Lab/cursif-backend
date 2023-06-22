defmodule CursifWeb.Schema.AccountTypesTest do
  use CursifWeb.ConnCase

  import Cursif.AccountsFixtures, only: [create_unique_user: 1, authenticated: 1, unique_user_attributes: 0]

  setup [:create_unique_user, :authenticated]

  describe "queries" do
    test "list of accounts", %{conn: conn, user: user, current_user: current_user, token: token} do
      conn = conn
      |> put_req_header("authorization", "Bearer " <> token)
      |> post("/api", %{
        "query" => """
          query {
            users {
              id
              username
            }
          }
        """
      })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "users" => [
                 %{
                   "id" => user.id,
                   "username" => user.username,
                 },
                 %{
                   "id" => current_user.id,
                   "username" => current_user.username,
                 }]
               }
             }
    end

    test "query a specific user", %{conn: conn, user: user, token: token} do
      conn = conn
      |> put_req_header("authorization", "Bearer " <> token)
      |> post("/api", %{
          "query" => """
            query getUser($id: ID!) {
              user(id: $id) {
                id
                username
              }
            }
          """,
          "variables" => %{id: user.id}
      })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "user" => %{
                   "id" => user.id,
                   "username" => user.username,
                 }
               }
             }
    end

    test "current user", %{conn: conn, current_user: current_user, token: token} do
      conn = conn
      |> put_req_header("authorization", "Bearer " <> token)
      |> post("/api", %{
        "query" => """
          query {
            me {
              id
              username
              email
              first_name
              last_name
            }
          }
        """
      })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "me" => %{
                   "id" => current_user.id,
                   "username" => current_user.username,
                   "email" => current_user.email,
                   "first_name" => current_user.first_name,
                   "last_name" => current_user.last_name,
                 }
               }
             }
    end
  end

  describe "authentification" do
    test "successful registration", %{conn: conn} do
      user = unique_user_attributes()

      conn = post(conn, "/api", %{
        "query" => """
          mutation Login($email: String!, $username: String!, $password: String!) {
            register(email: $email, username: $username, password: $password) {
              username
            }
          }
        """,
        "variables" => %{email: user.email, username: user.username, password: user.password}
      })

      assert json_response(conn, 200) == %{
        "data" => %{
          "register" => %{
            "username" => user.username
          }
        }
      }
    end

    setup [:create_unique_user]
    test "successful login", %{conn: conn, user: user, password: password} do
      conn = post(conn, "/api", %{
        "query" => """
          mutation Login($email: String!, $password: String!) {
            login(email: $email, password: $password) {
              user {
                username
              }
            }
          }
        """,
        "variables" => %{email: user.email, password: password}
      })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "login" => %{
                   "user" => %{
                     "username" => user.username
                   }
                 }
               }
             }
    end
  end
end
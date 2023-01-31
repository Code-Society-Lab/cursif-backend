defmodule CursifWeb.Schema.UserTypesTest do
  use CursifWeb.ConnCase
  import Cursif.UsersFixtures

  @user_query """
  query getUser($id: ID!) {
    user(id: $id) {
      id
      username
      email
    }
  }
  """

  @users_query """
  query {
    users {
      id
      username
      email
    }
  }
  """

  test "query: user", %{conn: conn} do
    user = user_fixture()

    conn = post(conn, "/api", %{
      "query" => @user_query,
      "variables" => %{id: user.id}
    })

    assert json_response(conn, 200) == %{
             "data" => %{
               "user" => %{
                 "id" => user.id,
                 "username" => "grace",
                 "email" => "grace.hopper@email.com",
               }
             }
           }
  end

  test "query: users", %{conn: conn} do
    user = user_fixture()

    conn = post(conn, "/api", %{
      "query" => @users_query,
    })

    assert json_response(conn, 200) == %{
             "data" => %{
               "users" => [%{
                 "id" => user.id,
                 "username" => "grace",
                 "email" => "grace.hopper@email.com",
               }]
             }
           }
  end
end
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cursif.Repo.insert!(%Cursif.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Cursif.{Repo, Accounts.User}

unless Repo.exists?(User) do
  user_attrs = %{
    email: "dev@example.com",
    password: "Password1234",
    username: "dev",
    first_name: "Dev",
    last_name: "Elopment"
  }

  %User{}
  |> User.changeset(user_attrs)
  |> Repo.insert!()
end
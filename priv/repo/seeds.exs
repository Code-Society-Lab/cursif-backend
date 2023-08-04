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
alias Cursif.Repo
alias Cursif.Accounts.User
alias Cursif.Notebooks.Notebook

if not Repo.exists?(User) && Application.get_env(:cursif, :env) == :dev do
  user_attrs = %{
    email: "dev@example.com",
    password: "Password1234",
    username: "dev",
    first_name: "Dev",
    last_name: "Elopment"
  }

  %{id: user_id} = %User{} |> User.changeset(user_attrs) |> Repo.insert!()

  notebook_attrs = %{
    title: "My First Notebook",
    description: "This is my first notebook",
    owner_id: user_id,
    owner_type: "user"
  }
  %Notebook{} |> Notebook.changeset(notebook_attrs) |> Repo.insert!()
end

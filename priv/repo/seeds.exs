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
alias Cursif.{Accounts, Notebooks}

defmodule Utils do
  def create_user(args \\ []) do
    username   = Keyword.get(args, :username, Faker.Internet.user_name())
    first_name = Keyword.get(args, :first_name, Faker.Person.first_name())
    last_name  = Keyword.get(args, :last_name, Faker.Person.last_name())
    email      = String.downcase("#{username}@example.com")

    {:ok, user} = Accounts.create_user(%{
      email: email,
      username: username,
      password: "Password1234",
      first_name: first_name,
      last_name: last_name
    })

    {:ok, user} = User.confirm_email(user)

    {:ok, notebook} = Notebooks.create_notebook(%{
      title: "#{user.username}'s First Notebook",
      description: "This is #{user.username}'s first notebook",
      owner_id: user.id,
      owner_type: "user"
    })

    %{user: user, notebook: notebook}
  end
end

if not Repo.exists?(User) && Application.get_env(:cursif, :env) == :dev do
  %{user: %{id: user_id}, notebook: %{id: notebook_id}} = 
    Utils.create_user(
      username: "dev",
      first_name: "Dev",
      last_name: "Elopment"
    )

  Enum.map 0..10, fn i -> 
    %{user: %{id: user_id}} = Utils.create_user() 

    if i < 3 do
      Notebooks.add_collaborator(%{notebook_id: notebook_id, user_id: user_id})
    end
  end
end

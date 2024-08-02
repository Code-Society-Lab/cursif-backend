defmodule CursifWeb.Schemas.NotebookTypes do

  use Absinthe.Schema.Notation
  alias CursifWeb.Resolvers.Notebooks

  @desc "Notebook representation"
  object :notebook do
    field :id, :id
    field :title, :string
    field :description, :string
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime

    field :pages, list_of(:page)
    field :collaborators, list_of(:collaborator)
    field :macros, list_of(:macro)

    field :favorite, :boolean

    field :owner, :partial_user do
      resolve(&Notebooks.get_owner/3)
    end
  end

  @desc "Macro representation"
  object :macro do
    field :id, :id
    field :name, :string
    field :pattern, :string
    field :code, :string
  end

	@desc "Collaborator representation"
  object :collaborator do
    field :user_id, :id, name: "id"

    # This is kinda ugly and would be more interesting to handle this
    # directly in the ecto schema. Maybe as a virtual field or smth. 
    field :username, :string do
      resolve(fn
        %{user: %Cursif.Accounts.User{} = user}, _arg, _ctx ->
          {:ok, user.username}
        _, _, _ ->
          {:ok, nil}
      end)
    end
    field :email, :string do
      resolve(fn
        %{user: %Cursif.Accounts.User{} = user}, _args, _ctx ->
          {:ok, user.email}
        _, _, _ ->
          {:ok, nil}
      end)
    end
  end

  @desc "Favorite representation"
  object :favorite do
    field :id, :id
    field :user_id, :string
    field :notebook_id, :string
  end
end

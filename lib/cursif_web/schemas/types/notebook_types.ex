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
    field :collaborators, list_of(:partial_user)
    field :macros, list_of(:macro)

    field :owner_id, :id
    field :owner_type, :string

    field :owner, :owner do
      resolve(&Notebooks.get_owner/3)
    end
  end

  union :owner do
    types([:partial_user])

    resolve_type fn
      %Cursif.Accounts.User{}, _ -> :partial_user
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
    field :id, :id
    field :notebook_id, :string
    field :user_id, :string
  end
end
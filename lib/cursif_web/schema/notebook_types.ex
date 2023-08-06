defmodule CursifWeb.Schema.NotebookTypes do
  @moduledoc """
  The User types.
  """
  use Absinthe.Schema.Notation
  alias CursifWeb.Resolvers.Notebooks
  alias CursifWeb.Resolvers.Macros
  alias CursifWeb.Resolvers.Collaborators

  @desc "Notebook representation"
  object :notebook do
    field :id, :id
    field :title, :string
    field :description, :string
    field :owner_id, :id
    field :owner_type, :string
    field :pages, list_of(:page)
    field :collaborators, list_of(:partial_user)
    field :macros, list_of(:macro)

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
    field :notebooks, list_of(:notebook)
    field :users, list_of(:user)
  end

  @desc "Notebook queries"
  object :notebook_queries do
    @desc "Get the list of notebooks"
    field :notebooks, list_of(:notebook) do
      resolve(&Notebooks.list_notebooks/2)
    end

    @desc "Get a notebook by id"
    field :notebook, :notebook do
      arg(:id, non_null(:id))
      resolve(&Notebooks.get_notebook_by_id/2)
    end

    @desc "Get a macro by id"
    field :macro, :macro do
      arg(:id, non_null(:id))
      resolve(&Macros.get_macro_by_id/2)
    end

    @desc "Get the list of macros"
    field :macros, list_of(:macro) do
      resolve(&Macros.list_macros/2)
    end

    @desc "Get a collaborator by id"
    field :collaborator, :collaborator do
      arg(:id, non_null(:id))
      resolve(&Collaborators.get_collaborator_by_id/2)
    end

    @desc "Get the list of collaborators"
    field :collaborators, list_of(:collaborator) do
      resolve(&Collaborators.list_collaborators/2)
    end
  end

  # Mutation objects
  object :notebook_mutations do
    @desc "Create a notebook"
    field :create_notebook, :notebook do
      arg(:title, non_null(:string))
      arg(:description, non_null(:string))
      arg(:owner_id, non_null(:id))
      arg(:owner_type, non_null(:string))

      resolve(&Notebooks.create_notebook/2)
    end

    @desc "Update a notebook"
    field :update_notebook, :notebook do
      arg(:id, non_null(:id))
      arg(:title, :string)
      arg(:description, :string)
      arg(:owner_id, :id)
      arg(:owner_type, :string)

      resolve(&Notebooks.update_notebook/2)
    end

    @desc "Delete an notebook"
    field :delete_notebook, :notebook do
        arg(:id, non_null(:id))

        resolve(&Notebooks.delete_notebook/2)
    end

    @desc "Create a macro"
    field :create_macro, :macro do
      arg(:name, non_null(:string))
      arg(:pattern, non_null(:string))
      arg(:code, non_null(:string))
      arg(:notebook_id, non_null(:id))

      resolve(&Macros.create_macro/2)
    end

    @desc "Update an macro"
    field :update_macro, :macro do
        arg(:id, non_null(:id))
        arg(:name, :string)
        arg(:pattern, :string)
        arg(:code, :string)

        resolve(&Macros.update_macro/2)
    end

    @desc "Delete an macro"
    field :delete_macro, :macro do
        arg(:id, non_null(:id))

        resolve(&Macros.delete_macro/2)
    end

    @desc "Create a collaborator"
    field :create_collaborator, :collaborator do
      arg(:notebook_id, non_null(:id))
      arg(:user_id, non_null(:id))

      resolve(&Collaborators.create_collaborator/2)
    end

    @desc "Update an collaborator"
    field :update_collaborator, :collaborator do
        arg(:id, non_null(:id))
        arg(:notebook_id, :id)
        arg(:user_id, :id)

        resolve(&Collaborators.update_collaborator/2)
    end

    @desc "Delete an collaborator"
    field :delete_collaborator, :collaborator do
        arg(:id, non_null(:id))

        resolve(&Collaborators.delete_collaborator/2)
    end
  end
end
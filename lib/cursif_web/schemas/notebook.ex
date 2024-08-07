defmodule CursifWeb.Schemas.Notebook do
    @moduledoc """
    The User types.
    """
    use Absinthe.Schema.Notation

    alias CursifWeb.Resolvers.Notebooks
    alias CursifWeb.Resolvers.Macros
    alias CursifWeb.Resolvers.Collaborators
    alias CursifWeb.Resolvers.Favorites

    object :notebook_queries do
      @desc "Get the list of notebooks"
      field :notebooks, list_of(:notebook) do
        arg(:favorite, :boolean, default_value: false)
        resolve(&Notebooks.list_notebooks/2)
      end

      @desc "Get a notebook by id"
      field :notebook, :notebook do
        arg(:id, non_null(:id))

        middleware Speakeasy.LoadResourceByID, &Cursif.Notebooks.get_notebook!/1
        middleware Speakeasy.Authz, {Cursif.Notebooks, :collaborator}

        resolve(&Notebooks.get_notebook_by_id/2)
      end

      @desc "Get a macro by id"
      field :macro, :macro do
        arg(:id, non_null(:id))
        resolve(&Macros.get_macro_by_id/2)
      end

      @desc "Get the list of macros for the given notebook"
      field :macros, list_of(:macro) do
        arg(:notebook_id, non_null(:id))

        middleware Speakeasy.LoadResource, fn(%{notebook_id: notebook_id}) ->
          Cursif.Notebooks.get_notebook!(notebook_id)
        end
        middleware Speakeasy.Authz, {Cursif.Notebooks, :collaborator}

        resolve(&Macros.list_macros/2)
      end
    end

    object :notebook_mutations do
      @desc "Create a notebook"
      field :create_notebook, :notebook do
        arg(:title, non_null(:string))
        arg(:description, :string)
        arg(:owner_id, non_null(:id))
        arg(:owner_type, :string, default_value: "user")

        resolve(&Notebooks.create_notebook/2)
      end

      @desc "Update a notebook"
      field :update_notebook, :notebook do
        arg(:id, non_null(:id))
        arg(:title, :string)
        arg(:description, :string)
        arg(:owner_id, :id)
  
        middleware Speakeasy.LoadResourceByID, &Cursif.Notebooks.get_notebook!/1
        middleware Speakeasy.Authz, {Cursif.Notebooks, :owner}

        resolve(&Notebooks.update_notebook/2)
      end

      @desc "Delete an notebook"
      field :delete_notebook, :notebook do
        arg(:id, non_null(:id))
  
        middleware Speakeasy.LoadResourceByID, &Cursif.Notebooks.get_notebook!/1
        middleware Speakeasy.Authz, {Cursif.Notebooks, :owner}

        resolve(&Notebooks.delete_notebook/2)
      end

      @desc "Create a macro"
      field :create_macro, :macro do
        arg(:title, non_null(:string))
        arg(:pattern, non_null(:string))
        arg(:code, non_null(:string))
        arg(:notebook_id, non_null(:id))

        middleware Speakeasy.LoadResource, fn(%{notebook_id: notebook_id}) -> 
          Cursif.Notebooks.get_notebook!(notebook_id) 
        end
        middleware Speakeasy.Authz, {Cursif.Notebooks, :collaborator}
  
        resolve(&Macros.create_macro/2)
      end

      @desc "Update an macro"
      field :update_macro, :macro do
        arg(:id, non_null(:id))
        arg(:title, :string)
        arg(:pattern, :string)
        arg(:code, :string)

        middleware Speakeasy.LoadResourceByID, fn(id) -> 
          id
          |> Cursif.Macros.get_macro!()
          |> Cursif.Notebooks.get_notebook!() 
        end
        middleware Speakeasy.Authz, {Cursif.Notebooks, :collaborator}

        resolve(&Macros.update_macro/2)
      end

      @desc "Delete an macro"
      field :delete_macro, :macro do
        arg(:id, non_null(:id))

        middleware Speakeasy.LoadResourceByID, fn(id) -> 
          id
          |> Cursif.Macros.get_macro!()
          |> Cursif.Notebooks.get_notebook!() 
        end
        middleware Speakeasy.Authz, {Cursif.Notebooks, :owner}

        resolve(&Macros.delete_macro/2)
      end

      @desc "Add a collaborator"
      field :add_collaborator, :collaborator do
        arg(:notebook_id, non_null(:id))
        arg(:email, non_null(:string))
  
        middleware Speakeasy.LoadResource, fn(%{notebook_id: notebook_id}) -> 
          Cursif.Notebooks.get_notebook!(notebook_id) 
        end
        middleware Speakeasy.Authz, {Cursif.Notebooks, :owner}

        resolve(&Collaborators.add_collaborator/2)
      end

      @desc "Delete an collaborator"
      field :delete_collaborator, :collaborator do
        arg(:notebook_id, non_null(:id))
        arg(:user_id, non_null(:id))

        middleware Speakeasy.LoadResource, fn(%{notebook_id: notebook_id}) -> 
          Cursif.Notebooks.get_notebook!(notebook_id) 
        end
        middleware Speakeasy.Authz, {Cursif.Notebooks, :owner}

        resolve(&Collaborators.delete_collaborator/2)
      end

      @desc "Add to favorites"
      field :add_favorite, :favorite do
        arg(:notebook_id, non_null(:id))

        middleware Speakeasy.LoadResource, fn(%{notebook_id: notebook_id}) ->
          Cursif.Notebooks.get_notebook!(notebook_id)
        end
        middleware Speakeasy.Authz, {Cursif.Notebooks, :collaborator}

        resolve(&Favorites.add_favorite/2)
      end

      @desc "Remove from favorites"
      field :remove_favorite, :favorite do
        arg(:notebook_id, non_null(:id))

        resolve(&Favorites.remove_favorite/2)
      end
    end
  end

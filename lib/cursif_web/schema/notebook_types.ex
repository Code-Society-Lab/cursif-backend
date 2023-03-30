defmodule CursifWeb.Schema.NotebookTypes do
  @moduledoc """
  The User types.
  """

  use Absinthe.Schema.Notation
  alias CursifWeb.Resolvers.Notebooks

  @desc "Notebook representation"
  object :notebook do
    field :id, :id
    field :title, :string
    field :description, :string
    field :visibility, :string
    field :pages, list_of(:page)
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
  end

  # Mutation objects
  object :notebook_mutations do
    @desc "Create a notebook"
    field :create_notebook, :notebook do
      arg(:title, non_null(:string))
      arg(:description, non_null(:string))
      arg(:visibility, non_null(:string))

      resolve(&Notebooks.create_notebook/2)
    end
  end
end
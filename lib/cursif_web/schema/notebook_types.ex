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

    @desc """
    Get a list of available notebooks
    """
    field :list_notebooks, list_of(:notebook) do
      resolve(&Notebook.list_notebooks/2)
    end
  end

  object :list_notebooks do
    @desc """
    Get a list of available notebooks
    """
    field :notebooks, list_of(:notebook) do
      resolve(&Notebook.list_notebooks/2)
    end
  end
end
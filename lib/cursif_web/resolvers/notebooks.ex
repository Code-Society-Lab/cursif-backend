defmodule CursifWeb.Resolvers.Notebooks do
  alias Cursif.Notebooks
  alias Cursif.Notebooks.Notebook

  @spec list_notebooks(map(), map()) :: {:ok, list(Notebook.t())}
  def list_notebooks(_args, _context) do
    {:ok, Notebooks.list_notebooks()}
  end

  @spec get_notebook_by_id(map(), map()) :: {:ok, Notebook.t()}
  def get_notebook_by_id(%{id: id}, _context) do
    {:ok, Notebooks.get_notebook!(id)}
  end

  @spec create_notebook(map(), map()) :: {:ok, Notebook.t()}
  def create_notebook(notebook, _context) do
    case Notebooks.create_notebook(notebook) do
      {:ok, notebook} -> {:ok, notebook}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
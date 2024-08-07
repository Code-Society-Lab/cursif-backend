defmodule CursifWeb.Resolvers.Notebooks do
  alias Cursif.Notebooks
  alias Cursif.Notebooks.Notebook

  @spec list_notebooks(map(), map()) :: {:ok, list(Notebook.t())}
  def list_notebooks(%{favorite: favorite}, %{context: %{current_user: current_user}}) do
    {:ok, Notebooks.list_notebooks(current_user, favorite: favorite)}
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

  @spec update_notebook(map(), map()) :: {:ok, Notebook.t()} | {:error, atom()}
  def update_notebook(%{id: id} = args, _context) do
    notebook = Notebooks.get_notebook!(id)

    case Notebooks.update_notebook(notebook, args) do
      {:ok, notebook} -> {:ok, notebook}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @spec delete_notebook(map(), map()) :: {:ok, Notebook.t()} | {:error, atom()}
  def delete_notebook(%{id: id}, _context) do
    notebook = Notebooks.get_notebook!(id)

    case Notebooks.delete_notebook(notebook) do
      {:ok, notebook} -> {:ok, notebook}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @spec get_owner(map(), map(), map()) :: {:ok, User.t()}
  def get_owner(notebook, _args, _context) do
    {:ok, Notebooks.get_owner!(notebook)}
  end
end

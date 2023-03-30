defmodule CursifWeb.Resolvers.Notebooks do
  alias Cursif.Accounts.User
  alias Cursif.Notebooks
  alias Cursif.Notebooks.Notebook

  @spec list_notebooks(map(), %{context: %{current_user: User.t()}}) :: {:ok, list(User.t())}
  def list_notebooks(_args, %{context: %{current_user: _current_user}}) do
    {:ok, Notebooks.list_notebooks()}
  end
  def list_notebooks(_args, _context), do: {:error, :unauthenticated}

  @spec get_notebook_by_id(map(), %{context: %{current_user: User.t()}}) :: {:ok, User.t()}
  def get_notebook_by_id(%{id: id}, %{context: %{current_user: _current_user}}) do
    {:ok, Notebooks.get_notebook!(id)}
  end
  def get_notebook_by_id(_args, _context), do: {:error, :unauthenticated}

  @spec create_notebook(map(), %{context: %{current_user: User.t()}}) :: {:ok, User.t()}
  def create_notebook(%{title: title, description: description, visibility: visibility}, %{context: %{current_user: _current_user}}) do
    case Notebooks.create_notebook(%{title: title, description: description, visibility: visibility}) do
      {:ok, notebook} -> {:ok, notebook}
      {:error, changeset} -> {:error, changeset}
    end
  end
  def create_notebook(_args, _context), do: {:error, :unauthenticated}
end
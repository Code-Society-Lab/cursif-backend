defmodule CursifWeb.Resolvers.Pages do
  alias Cursif.Pages
  alias Cursif.Pages.Page
  alias Cursif.Notebooks.Notebook

  @spec get_page_by_id(map(), map()) :: {:ok, Page.t()} | {:error, atom()}
  def get_page_by_id(%{id: id}, _context) do
    {:ok, Pages.get_page!(id)}
  rescue _ ->
    {:error, :page_not_found}
  end

  @spec create_page(map(), map()) :: {:ok, Page.t()} | {:error, atom()}
  def create_page(args, %{context: %{current_user: current_user}}) do
    case Pages.create_page(Map.merge(args, %{author_id: current_user.id})) do
      {:ok, page} -> {:ok, page}
      {:error, changeset} -> {:error, changeset}
    end
  end

  # Perhaps it should be defined in the context rather than here
  @spec get_parent(map(), map()) :: {:ok, Page.t()} | {:error, atom()}
  def get_parent(%{parent_id: parent_id, parent_type: "page"}, _context) do
    {:ok, Pages.get_page!(parent_id)}
  end

  @spec get_parent(map(), map()) :: {:ok, Notebook.t()} | {:error, atom()}
  def get_parent(%{parent_id: parent_id, parent_type: "notebook"}, _context) do
    {:ok, Notebooks.get_notebook!(parent_id)}
  end

  def get_parent(_args, _context) do
    {:error, :parent_not_found}
  end
end

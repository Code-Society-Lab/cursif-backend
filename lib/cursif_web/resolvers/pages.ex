defmodule CursifWeb.Resolvers.Pages do
  alias Cursif.Pages
  alias Cursif.Pages.Page

  @spec get_page_by_id(map(), %{context: %{current_user: User.t()}}) :: {:ok, list(User.t())}
  def get_page_by_id(%{id: id}, %{context: %{current_user: _current_user}}) do
    {:ok, Pages.get_page!(id)}
  rescue _ ->
    {:error, :page_not_found}
  end
  def get_page_by_id(_args, _context), do: {:error, :unauthenticated}


  @spec create_page(map(), %{context: %{current_user: User.t()}}) :: {:ok, Page.t()} | {:error, list(map())}
  def create_page(args, %{context: %{current_user: current_user}}) do
    case Pages.create_page(Map.merge(args, %{author_id: current_user.id})) do
      {:ok, page} -> {:ok, page}
      {:error, changeset} -> {:error, changeset}
    end
  end
  def create_page(_args, _context), do: {:error, :unauthenticated}
end

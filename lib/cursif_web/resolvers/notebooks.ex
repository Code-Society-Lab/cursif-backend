defmodule CursifWeb.Resolvers.Notebooks do
  alias Cursif.Accounts.User
  alias Cursif.Notebooks
  alias Cursif.Notebooks.Notebook

  @spec list_notebooks(map(), %{context: %{current_user: User.t()}}) :: {:ok, list(User.t())}
  def list_notebooks(_args, %{context: %{current_user: _current_user}}) do
    {:ok, Notebooks.list_notebooks()}
  end
  def list_notebooks(_args, _context), do: {:error, :unauthenticated}
end
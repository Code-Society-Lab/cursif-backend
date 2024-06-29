defmodule CursifWeb.Resolvers.Favorites do
  alias Cursif.Notebooks
  alias Cursif.Notebooks.Favorite

  @spec add_favorite(map(), map()) :: {:ok, Favorite.t()} | {:error, atom()}
  def add_favorite(%{notebook_id: notebook_id}, %{context: %{current_user: current_user}}) do
    Notebooks.get_notebook!(
      notebook_id,
      user: current_user
    )

    case Notebooks.add_favorite(%{notebook_id: notebook_id, user_id: current_user.id}) do
      {:ok, favorite} -> {:ok, favorite}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @spec remove_favorite(map(), map()) :: {:ok, Favorite.t()} | {:error, atom()}
  def remove_favorite(%{notebook_id: notebook_id}, %{context: %{current_user: current_user}}) do
    Notebooks.get_notebook!(
      notebook_id,
      user: current_user
    )

    case Notebooks.delete_favorite_by_user_id(notebook_id, current_user.id) do
      {1, nil} -> {:ok, %{message: "favorite removed successfully"}}
      {0, nil} -> {:error, :not_found}
    end
  end
end

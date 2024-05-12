defmodule CursifWeb.Resolvers.Favorites do
	alias Cursif.Notebooks
	alias Cursif.Notebooks.Favorite

  @spec add_favorite(map(), map()) :: {:ok, Favorite.t()}  | {:error, atom()}
  def add_favorite(favorite, %{context: %{current_user: current_user}}) do
    Notebooks.get_notebook!(
      favorite.notebook_id,
      owner: current_user
    )

    case Notebooks.add_favorite(favorite) do
      {:ok, favorite} -> {:ok, favorite}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @spec remove_favorite(map(), map()) :: {:ok, Favorite.t()} | {:error, atom()}
  def remove_favorite(favorite, %{context: %{current_user: current_user}}) do
    Notebooks.get_notebook!(
      favorite.notebook_id,
      owner: current_user
    )
    case Notebooks.delete_favorite_by_user_id(favorite.notebook_id, favorite.user_id) do
      {1, nil} -> {:ok, %{message: "favorite removed successfully"}}
      {0, nil} -> {:error, :not_found}
    end
  end
end

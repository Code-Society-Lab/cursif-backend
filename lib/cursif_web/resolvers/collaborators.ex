defmodule CursifWeb.Resolvers.Collaborators do
    alias Cursif.Notebooks
    alias Cursif.Notebooks.Collaborator

    @spec get_collaborator_by_id(map(), map()) :: {:ok, Collaborator.t()}
    def get_collaborator_by_id(%{id: id}, %{context: %{current_user: current_user}}) do
        {:ok, Notebooks.get_collaborator!(id, user: current_user)}
    rescue
        Ecto.NoResultsError -> {:error, :not_found}
    end

    @spec add_collaborator(map(), map()) :: {:ok, Collaborator.t()}  | {:error, atom()}
    def add_collaborator(collaborator, %{context: %{current_user: current_user}}) do
        notebook = Notebooks.get_notebook!(
            collaborator.notebook_id, 
            owner: current_user
        )
        if notebook do
            case Notebooks.add_collaborator(collaborator) do
                {:ok, collaborator} -> {:ok, collaborator}
                {:error, changeset} -> {:error, changeset}
            end
        else
            {:error, :unauthorized}
        end
    end


    @spec delete_collaborator(map(), map()) :: {:ok, Collaborator.t()} | {:error, atom()}
    def delete_collaborator(collaborator, %{context: %{current_user: current_user}}) do
        notebook = Notebooks.get_notebook!(
            collaborator.notebook_id, 
            owner: current_user
        )

        if notebook do
            case Notebooks.delete_collaborator_by_user_id(collaborator.notebook_id, collaborator.user_id) do
                {1, nil} -> {:ok, %{message: "collaborator removed successfully"}}
                {0, nil} -> {:error, :not_found}
            end
        else
            {:error, :unauthorized}
        end
    end
end

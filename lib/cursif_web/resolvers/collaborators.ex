defmodule CursifWeb.Resolvers.Collaborators do
    alias Cursif.Notebooks
    alias Cursif.Notebooks.Collaborator


    @spec get_collaborator_by_id(map(), map()) :: {:ok, Collaborator.t()}
    def get_collaborator_by_id(%{id: id}, %{context: %{current_user: current_user}}) do
        {:ok, Notebooks.get_collaborator!(id, user: current_user)}
    rescue
        Ecto.NoResultsError -> {:error, :not_found}
    end

    @spec create_collaborator(map(), map()) :: {:ok, Collaborator.t()}
    def create_collaborator(collaborator, %{current_user: current_user}) do
        notebook = Notebooks.get_notebook!(
            collaborator.notebook_id, 
            owner: current_user, 
            preloads: []
        )

        if notebook do
            case Notebooks.create_collaborator(collaborator) do
                {:ok, collaborator} -> {:ok, collaborator}
                {:error, changeset} -> {:error, changeset}
            end
        end
        {:error, :unauthorized}
    end

    @spec delete_collaborator(map(), map()) :: {:ok, Collaborator.t()} | {:error, atom()}
    def delete_collaborator(%{id: id}, _context) do
        collaborator = Notebooks.get_collaborator!(id)

        case Notebooks.delete_collaborator(collaborator) do
            {:ok, collaborator} -> {:ok, collaborator}
            {:error, changeset} -> {:error, changeset}
        end
    rescue
        Ecto.NoResultsError -> {:error, :not_found}
    end
end
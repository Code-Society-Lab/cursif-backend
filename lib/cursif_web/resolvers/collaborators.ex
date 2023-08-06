defmodule CursifWeb.Resolvers.Collaborators do
    alias Cursif.Collaborators
    alias Cursif.Notebooks.Collaborator

    @spec list_collaborators(map(), map()) :: {:ok, list(Collaborator.t())}
    def list_collaborators(_args, _context) do
        {:ok, Collaborators.list_collaborators()}
    rescue _ ->
        {:error, :not_found}
    end

    @spec get_collaborator_by_id(map(), map()) :: {:ok, Collaborator.t()}
    def get_collaborator_by_id(%{id: id}, _context) do
      {:ok, Collaborators.get_collaborator!(id)}
    rescue _ ->
      {:error, :not_found}
    end
    

    @spec create_collaborator(map(), map()) :: {:ok, Collaborator.t()}
    def create_collaborator(collaborator, _context) do
        case Collaborators.create_collaborator(collaborator) do
            {:ok, collaborator} -> {:ok, collaborator}
            {:error, changeset} -> {:error, changeset}
        end
    end

    @spec update_collaborator(map(), map()) :: {:ok, Collaborator.t()} | {:error, atom()}
    def update_collaborator(%{id: id} = args, _context) do
        collaborator = Collaborators.get_collaborator!(id)
      
        case Collaborators.update_collaborator(collaborator, args) do
            {:ok, collaborator} -> {:ok, collaborator}
            {:error, changeset} -> {:error, changeset}
        end
    end

    @spec delete_collaborator(map(), map()) :: {:ok, Collaborator.t()} | {:error, atom()}
    def delete_collaborator(%{id: id}, _context) do
        collaborator = Collaborators.get_collaborator!(id)

        case Collaborators.delete_collaborator(collaborator) do
            {:ok, collaborator} -> {:ok, collaborator}
            {:error, changeset} -> {:error, changeset}
        end
    end
end
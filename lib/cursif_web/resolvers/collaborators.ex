defmodule CursifWeb.Resolvers.Collaborators do
    alias Cursif.Notebooks
    alias Cursif.Notebooks.Collaborator

    @spec create_collaborator(map(), map()) :: {:ok, Collaborator.t()}
    def create_collaborator(collaborator, _context) do
        case Notebooks.create_collaborator(collaborator) do
            {:ok, collaborator} -> {:ok, collaborator}
            {:error, changeset} -> {:error, changeset}
        end
    end

    @spec delete_collaborator(map(), map()) :: {:ok, Collaborator.t()} | {:error, atom()}
    def delete_collaborator(%{id: id}, _context) do
        collaborator = Notebooks.get_collaborator!(id)

        case Notebooks.delete_collaborator(collaborator) do
            {:ok, collaborator} -> {:ok, collaborator}
            {:error, changeset} -> {:error, changeset}
        end
    end
end
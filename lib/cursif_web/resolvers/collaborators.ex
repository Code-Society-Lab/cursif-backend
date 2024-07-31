defmodule CursifWeb.Resolvers.Collaborators do
	alias Cursif.Notebooks
	alias Cursif.Notebooks.Collaborator
	alias Cursif.Accounts

	@spec add_collaborator(map(), map()) :: {:ok, Collaborator.t()}  | {:error, atom()}
	def add_collaborator(collaborator, _context) do
		case Notebooks.add_collaborator(collaborator) do
			{:ok, collaborator} -> {:ok, collaborator}
			{:error, changeset} -> {:error, changeset}
		end
	end

	@spec delete_collaborator(map(), map()) :: {:ok, Collaborator.t()} | {:error, atom()}
	def delete_collaborator(collaborator, _context) do
		case Notebooks.delete_collaborator(collaborator) do
			{1, nil} -> {:ok, %{message: "collaborator removed successfully"}}
			{0, nil} -> {:error, :not_found}
		end
	end
end

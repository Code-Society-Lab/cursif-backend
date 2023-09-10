defmodule CursifWeb.Resolvers.Collaborators do
	alias Cursif.Notebooks
	alias Cursif.Notebooks.Collaborator

	@spec add_collaborator(map(), map()) :: {:ok, Collaborator.t()}  | {:error, atom()}
	def add_collaborator(collaborator, %{context: %{current_user: current_user}}) do
		Notebooks.get_notebook!(collaborator.notebook_id)
			
		case Notebooks.add_collaborator(collaborator) do
			{:ok, collaborator} -> {:ok, collaborator}
			{:error, changeset} -> {:error, changeset}
		end
	end

	@spec delete_collaborator(map(), map()) :: {:ok, Collaborator.t()} | {:error, atom()}
	def delete_collaborator(collaborator, %{context: %{current_user: current_user}}) do
		Notebooks.get_notebook!(collaborator.notebook_id)

		case Notebooks.delete_collaborator_by_user_id(collaborator.notebook_id, collaborator.user_id) do
			{1, nil} -> {:ok, %{message: "collaborator removed successfully"}}
			{0, nil} -> {:error, :not_found}
		end
	end
end

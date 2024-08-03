defmodule CursifWeb.Resolvers.Collaborators do
	alias Cursif.Notebooks
	alias Cursif.Notebooks.Collaborator
	alias Cursif.Accounts

	@spec add_collaborator(map(), map()) :: {:ok, Collaborator.t()}  | {:error, atom()}
	def add_collaborator(collaborator, %{context: %{current_user: current_user}}) do
		user = Accounts.get_user_by_email!(collaborator.email)
		collaborator_attrs = %{notebook_id: collaborator.notebook_id, user_id: user.id}

		case Notebooks.add_collaborator(collaborator_attrs) do
			{:ok, collaborator} ->
				case Notebooks.send_notification(user, collaborator.notebook_id, current_user) do
					{:ok, _} -> {:ok, collaborator}
					{:error, reason} -> {:error, reason}
				end
			{:error, changeset} -> {:error, changeset}
		end
	end

	@spec delete_collaborator(map(), map()) :: {:ok, Collaborator.t()} | {:error, atom()}
	def delete_collaborator(collaborator, _context) do
		case Notebooks.delete_collaborator_by_user_id(collaborator.notebook_id, collaborator.user_id) do
			{1, nil} -> {:ok, %{message: "collaborator removed successfully"}}
			{0, nil} -> {:error, :not_found}
		end
	end
end
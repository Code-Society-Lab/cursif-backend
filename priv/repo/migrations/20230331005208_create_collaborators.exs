defmodule Cursif.Repo.Migrations.CreateCollaborators do
  use Ecto.Migration

  def change do
    create table(:collaborators) do
      add :notebook_id, references(:notebooks, type: :binary_id, on_delete: :delete_all)
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:collaborators, [:notebook_id, :user_id])
  end
end

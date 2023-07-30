defmodule Cursif.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :owner_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:organizations, [:name])
  end
end

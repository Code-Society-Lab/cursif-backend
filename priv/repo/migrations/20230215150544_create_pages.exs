defmodule Cursif.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :content, :text
      add :author_id, references(:users, type: :binary_id)

      # Add the polymorphic association to the parent model
      add :parent_id, :binary_id
      add :parent_type, :string

      timestamps()
    end

    # Add an index for the parent association
    create index(:pages, [:parent_id, :parent_type])
  end
end

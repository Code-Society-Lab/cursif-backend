defmodule Cursif.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:themes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      timestamps()
    end

    create table(:languages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      timestamps()
    end

    alter table(:users) do
      add :theme_id, references(:themes, type: :binary_id)
      add :language_id, references(:languages, type: :binary_id)
    end

    create unique_index(:themes, [:name])
    create unique_index(:languages, [:name])
  end
end

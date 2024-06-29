defmodule Cursif.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id)
      add :notebook_id, references(:notebooks, type: :binary_id)

      timestamps()
    end

    create unique_index(:favorites, [:user_id, :notebook_id])
  end
end

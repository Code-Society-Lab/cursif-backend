defmodule Cursif.Repo.Migrations.CreateNotebooks do
  use Ecto.Migration

  def change do
    create table(:notebooks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :string

      add :owner_id, :binary_id
      add :owner_type, :string


      timestamps()
    end

    create index(:notebooks, [:owner_id, :owner_type])
  end
end

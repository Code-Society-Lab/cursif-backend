defmodule Cursif.Repo.Migrations.CreateMacros do
  use Ecto.Migration

  def change do
    create table(:macros, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :pattern, :string
      add :code, :string
      add :notebook_id, references(:notebooks, type: :binary_id)

      timestamps()
    end
  end
end

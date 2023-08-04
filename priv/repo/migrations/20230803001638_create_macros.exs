defmodule Cursif.Repo.Migrations.CreateMacros do
  use Ecto.Migration

  def change do
    create table(:macros, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :pattern, :string
      add :code, :string

      timestamps()
    end
  end
end

defmodule Cursif.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :contents, :string

      timestamps()
    end
  end
end

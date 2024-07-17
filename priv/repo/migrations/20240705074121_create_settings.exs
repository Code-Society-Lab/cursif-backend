defmodule Cursif.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :theme, :string
      add :language, :string
    end
  end
end

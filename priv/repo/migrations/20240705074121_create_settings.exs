defmodule Cursif.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :theme_id, :integer
      add :language_id, :integer
    end
  end
end

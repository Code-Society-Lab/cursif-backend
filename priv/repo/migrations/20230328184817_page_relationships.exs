defmodule Cursif.Repo.Migrations.PageRelationships do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :author_id, references(:users, type: :uuid)
      add :parent_id, references(:pages, type: :uuid)
    end
  end
end

defmodule Cursif.Repo.Migrations.CreateUserSessions do
  use Ecto.Migration

  def change do
    create table(:user_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :token, :text
      add :expires_at, :naive_datetime, default: nil
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:user_tokens, [:user_id])
  end
end

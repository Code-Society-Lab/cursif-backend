defmodule Cursif.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string, null: false
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, null: false
      add :phone_number, :string, null: true
      add :hashed_password, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end

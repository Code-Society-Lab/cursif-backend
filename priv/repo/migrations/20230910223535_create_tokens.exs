defmodule Cursif.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(@table, primary_key: false) do
      add :jti, :string, primary_key: true
      add :aud, :string, primary_key: true
      add :typ, :string
      add :iss, :string
      add :sub, :string
      add :exp, :bigint
      add :jwt, :text
      add :claims, :map
      timestamps()
    end

    create index(@table, [:jwt])
    create index(@table, [:sub])
    create index(@table, [:jti])
  end
end

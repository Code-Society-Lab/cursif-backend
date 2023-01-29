defmodule Cursif.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :first_name, :string
    field :hashed_password, :string
    field :last_name, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :first_name, :last_name, :email, :hashed_password])
    |> validate_required([:username, :first_name, :last_name, :email, :hashed_password])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end

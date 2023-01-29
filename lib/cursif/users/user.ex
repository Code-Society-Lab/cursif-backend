defmodule Cursif.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
               username: String.t(),
               email: String.t(),
               first_name: String.t() | nil,
               last_name: String.t() | nil,
               hashed_password: String.t(),
               # Timestamps
               inserted_at: any(),
               updated_at: any()
             }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :hashed_password, :string

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
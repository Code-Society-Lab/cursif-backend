defmodule Cursif.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    username: String.t(),
    email: String.t(),
    hashed_password: String.t(),
    first_name: String.t() | nil,
    last_name: String.t() | nil,

               # Timestamps
               inserted_at: DateTime.t(),
               updated_at: DateTime.t()
             }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true

    timestamps()
  end

  @doc false
  @spec changeset(User.t(), %{}) :: User.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :first_name, :last_name, :email, :password])
    |> validate_required([:username, :email, :password])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_email()
    |> validate_password()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_length(:password, min: 8, max: 160, message: "must be between 8 and 160 characters")
    |> validate_format(:password, ~r/[a-z]/, message: "must have at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "must have at least one upper case character")
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "must have at least one digit or punctuation character")
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> change(hashed_password: Argon2.hash_pwd_salt(password))
    |> delete_change(:password)
  end

  defp put_password_hash(changeset), do: changeset
end

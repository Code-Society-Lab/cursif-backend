defmodule Cursif.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cursif.Repo
  alias Cursif.Notebooks.Notebook

  @type t :: %__MODULE__{
    username: String.t(),
    email: String.t(),
    hashed_password: String.t(),
    first_name: String.t() | nil,
    last_name: String.t() | nil,

    confirmed_at: NaiveDateTime.t(),
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
    field :confirmed_at, :naive_datetime

    many_to_many :favorites, Notebook, join_through: Favorite

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

  @doc false
  @spec update_changeset(User.t(), %{}) :: User.t()
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :username, :email])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_email()
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

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_email(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now) |> Repo.update()
  end

  @doc """
  Updates the user's password.
  """
  def update_password(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_password()
  end
end

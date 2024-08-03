defmodule Cursif.Notebooks.Collaborator do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cursif.Notebooks.Notebook
  alias Cursif.Accounts.User

  @type t :: %__MODULE__{
    notebook: Notebook.t(),
    user: User.t(),

    # Timestamps
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "collaborators" do
    belongs_to :notebook, Notebook
    belongs_to :user, User

    timestamps()
  end

  @spec username(Collaborator.t()) :: String
  def username(%{user: user}) when not is_nil(user),
    do: user.username

  @spec email(Collaborator.t()) :: String
  def email(%{user: user}) when not is_nil(user),
    do: user.email

  @doc false
  @spec changeset(Collaborator.t(), %{}) :: Collaborator.t()
  def changeset(collaborator, attrs) do
    collaborator
    |> cast(attrs, [:notebook_id, :user_id])
    |> cast_assoc(:notebook)
    |> cast_assoc(:user)
    |> validate_required([:notebook_id, :user_id])
    |> unique_constraint([:notebook_id, :user_id], error_key: :user, message: "already a collaborator")
  end
end
defmodule Cursif.Notebooks.Notebook do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cursif.Repo

  alias Cursif.Accounts
  alias Cursif.Accounts.User
  alias Cursif.Notebooks.{Page, Collaborator, Macro}

  @type t :: %__MODULE__{
    title: String.t(),
    description: String.t(),
    owner_id: binary(),
    owner_type: String.t(),
    pages: [Page.t()],
    collaborators: [User.t()],
    macros: [Macro.t()],

    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notebooks" do
    field :description, :string
    field :title, :string
    field :owner_id, :binary_id
    field :owner_type, :string

    has_many :macros, Macro
    has_many :pages, Page, foreign_key: :parent_id
    many_to_many :collaborators, User, join_through: Collaborator

    timestamps()
  end

  @doc false
  @spec changeset(Notebook.t(), %{}) :: Notebook.t()
  def changeset(notebook, attrs) do
    notebook
    |> cast(attrs, [:title, :description, :owner_id, :owner_type])
    |> cast_assoc(:pages)
    |> validate_required([:title, :description, :owner_id, :owner_type])
    |> validate_association()
  end

  defp validate_association(%{changes: %{owner_type: "user", owner_id: owner_id}} = changeset) do
    Repo.get!(User, owner_id)
    changeset
  rescue
    Ecto.NoResultsError -> add_error(changeset, :owner_id, "is not a valid user")
  end

  defp validate_association(%{changes: %{owner_type: owner_type}} = changeset)
       when owner_type not in ["user", "organization"] do
    add_error(changeset, :owner_type, "is not a valid owner type")
  end

  defp validate_association(changeset),
    do: changeset


  @spec owner(Notebook.t()) :: User.t()
  def owner(%{owner_id: owner_id}),
    do: Accounts.get_user!(owner_id)

  @spec owner?(Notebook.t(), User.t()) :: boolean()
  def owner?(%{owner_id: owner_id}, %{id: user_id}),
    do: owner_id == user_id

  @spec collaborator?(Notebook.t(), User.t()) :: boolean()
  def collaborator?(%{owner_id: owner_id}, %{id: user_id}),
    do: Repo.exists?(Collaborator, owner_id: owner_id, user_id: user_id)
end

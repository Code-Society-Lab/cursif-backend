defmodule Cursif.Notebooks.Notebook do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cursif.Repo

  alias Cursif.Accounts.User
  alias Cursif.Notebooks.{Page, Macro, Favorite, Collaborator}

  @type t :: %__MODULE__{
    title: String.t(),
    description: String.t(),
    owner_id: binary(),
    owner_type: String.t(),

    pages: [Page.t()],
    collaborators: [Collaborator.t()],
    macros: [Macro.t()],

    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notebooks" do
    field :title, :string
    field :description, :string
    field :owner_id, :binary_id
    field :owner_type, :string, default: "user"

    has_many :macros, Macro
    has_many :pages, Page, foreign_key: :parent_id
    has_many :collaborators, Collaborator

    many_to_many :favorites, User, join_through: Favorite

    timestamps()
  end

  @doc false
  @spec changeset(Notebook.t(), %{}) :: Notebook.t()
  def changeset(notebook, attrs) do
    notebook
    |> cast(attrs, [:title, :description, :owner_id, :owner_type])
    |> cast_assoc(:pages)
    |> validate_required([:title, :owner_id, :owner_type])
    |> validate_association()
  end

  defp validate_association(%{changes: %{owner_type: "user", owner_id: owner_id}} = changeset) do
    if Repo.exists?(User, owner_id) do
      changeset
    else
      add_error(changeset, :owner_id, "is not a valid user")
    end
  end

  defp validate_association(changeset),
    do: changeset
end

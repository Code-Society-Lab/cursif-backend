defmodule Cursif.Notebooks.Notebook do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cursif.Pages.Page
  alias Cursif.Accounts.User
  alias Cursif.Notebooks.Collaborator
  alias Cursif.Visibility

  @type t :: %__MODULE__{
               title: String.t(),
               description: String.t(),
               visibility: Visibility,
               pages: [Page.t()],
               collaborators: [User.t()],

               # Timestamps
               inserted_at: any(),
               updated_at: any()
             }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notebooks" do
    field :description, :string
    field :title, :string
    field :visibility, Visibility
    field :owner_id, :binary_id
    field :owner_type, :string

    has_many :collaborators, User, through: Collaborator, join_keys: [notebook_id: :id, user_id: :id]
    has_many :pages, Page, foreign_key: :parent_id, where: [parent_type: "notebook"]

    timestamps()
  end

  @doc false
  @spec changeset(Notebook.t(), %{}) :: Notebook.t()
  def changeset(notebook, attrs) do
    notebook
    |> cast(attrs, [:title, :description, :visibility])
    |> cast_assoc(:pages)
    |> validate_required([:title, :description, :visibility])
    |> validate_parent_association()
  end

  def validate_parent_association(%{changes: %{owner_type: "user", owner_id: owner_id}} = changeset) do
    Repo.get!(User, owner_id)
    changeset
  rescue
    Ecto.NoResultsError -> add_error(changeset, :owner_id, "is not a valid user")
  end

  def validate_parent_association(_) do
    add_error(changeset, :owner_type, "is not a valid owner type")
  end
end
defmodule Cursif.Notebooks.Notebook do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cursif.Pages.Page
  alias Cursif.Visibility

  @type t :: %__MODULE__{
               title: String.t(),
               description: String.t(),
               visibility: Visibility,
               pages: [Page.t()],
               # Timestamps
               inserted_at: any(),
               updated_at: any()
             }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notebooks" do
    field :description, :string
    field :title, :string
    field :visibility, Cursif.Visibility

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
  end
end
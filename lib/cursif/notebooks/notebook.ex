defmodule Cursif.Notebooks.Notebook do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
               title: String.t(),
               description: String.t(),
               visibility: Cursif.Visibility,
               # Timestamps
               inserted_at: any(),
               updated_at: any()
             }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notebooks" do
    field :description, :string
    field :title, :string
    field :visibility,   Cursif.Visibility

    timestamps()
  end

  @doc false
  @spec changeset(Notebook.t(), %{}) :: Notebook.t()
  def changeset(notebook, attrs) do
    notebook
    |> cast(attrs, [:title, :description, :visibility])
    |> validate_required([:title, :description, :visibility])
  end
end
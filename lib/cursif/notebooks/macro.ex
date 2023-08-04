defmodule Cursif.Notebooks.Macro do
    use Ecto.Schema
    import Ecto.Changeset

    alias Cursif.Notebooks.Macro
    alias Cursif.Notebooks.Notebook

    @type t :: %__MODULE__{
        name: String.t(),
        pattern: String.t(),
        code: String.t(),
        notebook: Notebook.t(),

        # Timestamps
        inserted_at: any(),
        updated_at: any()
    }

    @primary_key {:id, :binary_id, autogenerate: true}
    @foreign_key_type :binary_id
    schema "macros" do
        field :name, :string
        field :pattern, :string
        field :code, :string

        belongs_to :notebook, Notebook

        timestamps()
    end

    @doc false
    @spec changeset(Macro.t(), %{}) :: Macro.t()
    def changeset(macro, attrs) do
        macro
        |> cast(attrs, [:name, :pattern, :code, :notebook_id])
        |> cast_assoc(:notebook)
        |> validate_required([:name, :pattern, :code, :notebook_id])
    end
end
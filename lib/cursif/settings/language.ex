defmodule Cursif.Settings.Language do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    name: String.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "languages" do
    field :name, :string

    timestamps()
  end

  @doc false
  @spec changeset(Language.t(), %{}) :: Language.t()
  def changeset(language, attrs) do
    language
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

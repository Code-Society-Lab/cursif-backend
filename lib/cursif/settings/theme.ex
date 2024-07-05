defmodule Cursif.Settings.Theme do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    name: String.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "themes" do
    field :name, :string

    timestamps()
  end

  @doc false
  @spec changeset(Theme.t(), %{}) :: Theme.t()
  def changeset(theme, attrs) do
    theme
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

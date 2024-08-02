defmodule Cursif.Notebooks.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cursif.Accounts.User
  alias Cursif.Notebooks.Notebook

  @type t :: %__MODULE__{
    user: User.t(),
    notebook: Notebook.t(),
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "favorites" do
    belongs_to(:user, User)
    belongs_to(:notebook, Notebook)

    timestamps()
  end

  @doc false
  @spec changeset(Favorite.t(), %{}) :: Favorite.t()
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, [:user_id, :notebook_id])
    |> cast_assoc(:user)
    |> cast_assoc(:notebook)
    |> validate_required([:user_id, :notebook_id])
    |> unique_constraint([:user_id, :notebook_id], error_key: :notebook, message: "already a favorite")
  end
end

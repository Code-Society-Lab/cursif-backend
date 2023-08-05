defmodule Cursif.Notebooks.Collaborator do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cursif.Notebooks.Notebook
  alias Cursif.Accounts.User

  @type t :: %__MODULE__{
               notebook: Notebook.t(),
               user: User.t(),

               # Timestamps
               inserted_at: any(),
               updated_at: any()
             }

  schema "collaborators" do
    belongs_to :notebook, Notebook
    belongs_to :user, User

    timestamps()
  end

  @doc false
  @spec changeset(Collaborator.t(), %{}) :: Collaborator.t()
  def changeset(collaborator, attrs) do
    collaborator
    |> cast(attrs, [:notebook_id, :user_id])
    |> cast_assoc(:notebook)
    |> cast_assoc(:user)
    |> validate_required([:notebook_id, :user_id])
  end
end
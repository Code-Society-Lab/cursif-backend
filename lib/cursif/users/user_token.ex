defmodule Cursif.Users.UserToken do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cursif.Users.User

  @type t :: %__MODULE__{
               token: String.t(),
               user: User.t(),
               expires_at: any() | nil,
               # Timestamps
               inserted_at: any(),
               updated_at: any()
             }


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_tokens" do
    field :token, :string
    belongs_to :user, User
    field :expires_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(user_token, attrs) do
    user_token
    |> cast(attrs, [:token])
    |> validate_required([:token])
    |> put_assoc(:user, attrs.user)
  end
end

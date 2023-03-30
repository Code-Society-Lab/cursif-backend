defmodule Cursif.Pages.Page do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cursif.Accounts.User
  alias Cursif.Pages.Page

  @type t :: %__MODULE__{
               title: String.t(),
               contents: String.t(),
               author: User.t(),
               parent: Page.t(),
               # Timestamps
               inserted_at: any(),
               updated_at: any()
             }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pages" do
    field :title, :string
    field :contents, :string

    belongs_to :author, User

    has_many :children, Page, foreign_key: :parent_id
    belongs_to :parent, Page

    timestamps()
  end

  @doc false
  @spec changeset(Page.t(), %{}) :: Page.t()
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:title, :contents, :author_id, :parent_id])
    |> validate_required([:title, :author_id])
  end
end

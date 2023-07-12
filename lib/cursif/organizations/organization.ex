defmodule Cursif.Organizations.Organization do
    use Ecto.Schema

    alias Cursif.Organizations.Member
    alias Cursif.Notebooks
    alias Cursif.Notebooks.Notebook

    @type t :: %__MODULE__{
                name: String.t(),
                member: Member.t(),

                # Timestamps
                inserted_at: any(),
                updated_at: any()
            }

    schema "organizations" do
        field :name, :string

        has_many :member, Member, join_through: User

        timestamps()
    end

    @doc false
    @spec changeset(Member.t(), %{}) :: Member.t()
    def changeset(member, attrs) do
        member
        |> cast(attrs, [:title, :description, :visibility, :owner_id, :owner_type])
        |> cast_assoc(:member)
        |> validate_required([:title, :description, :visibility, :owner_id, :owner_type])
        |> validate_association()
    end

    defp validate_association(%{changes: %{owner_type: "user", owner_id: owner_id}} = changeset) do
        Repo.get!(User, owner_id)
        changeset
    rescue
        Ecto.NoResultsError -> add_error(changeset, :owner_id, "is not a valid user")
    end

    defp validate_association(changeset) do
        add_error(changeset, :owner_type, "is not a valid owner type")
    end
end

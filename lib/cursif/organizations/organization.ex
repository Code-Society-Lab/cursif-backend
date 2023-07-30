defmodule Cursif.Organizations.Organization do
    use Ecto.Schema
    import Ecto.Changeset
    alias Cursif.Repo

    alias Cursif.Organizations.Member
    alias Cursif.Accounts.User

    @type t :: %__MODULE__{
        name: String.t(),
        members: list(Member.t()),
        owner_id: binary(),

        # Timestamps
        inserted_at: any(),
        updated_at: any()
    }
    
    @primary_key {:id, :binary_id, autogenerate: true}
    @foreign_key_type :binary_id
    schema "organizations" do
        field :name, :string
        field :owner_id, :binary_id

        has_many :members, Member

        timestamps()
    end

    @doc false
    @spec changeset(Organization.t(), %{}) :: Organization.t()
    def changeset(organization, attrs) do
        organization
        |> cast(attrs, [:name, :owner_id])
        |> cast_assoc(:members)
        |> validate_required([:name, :owner_id])
        |> validate_association()
    end

    defp validate_association(%{changes: %{owner_id: owner_id}} = changeset) do
        Repo.get!(User, owner_id)
        changeset
    rescue
        Ecto.NoResultsError -> add_error(changeset, :owner_id, "is not a valid user")
    end

    defp validate_association(changeset),
        do: changeset

    @doc false
    @spec update_changeset(Organization.t(), %{}) :: Organization.t()
    def update_changeset(organization, attrs) do
        organization |> cast(attrs, [:name, :owner_id])
    end
end

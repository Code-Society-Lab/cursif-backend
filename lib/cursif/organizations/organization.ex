defmodule Cursif.Organizations.Organization do
    use Ecto.Schema
    import Ecto.Changeset
    alias Cursif.Repo

    alias Cursif.Organizations.Member
    alias Cursif.Accounts.User

    @type t :: %__MODULE__{
        name: String.t(),
        member: Member.t(),
        owner_id: binary(),
        owner_type: String.t(),

        # Timestamps
        inserted_at: any(),
        updated_at: any()
    }
    
    @primary_key {:id, :binary_id, autogenerate: true}
    @foreign_key_type :binary_id
    schema "organizations" do
        field :name, :string
        field :owner_id, :binary_id
        field :owner_type, :string

        many_to_many :member, Member, join_through: User

        timestamps()
    end

    @doc false
    @spec changeset(Organization.t(), %{}) :: Organization.t()
    def changeset(organization, attrs) do
        organization
        |> cast(attrs, [:name, :member, :owner_id, :owner_type])
        |> cast_assoc(:member)
        |> validate_required([:name, :member, :owner_id, :owner_type])
        |> validate_association()
    end

    defp validate_association(%{changes: %{owner_type: "admin", owner_id: owner_id}} = changeset) do
        Repo.get!(User, owner_id)
        changeset
    rescue
        Ecto.NoResultsError -> add_error(changeset, :owner_id, "is not a valid user")
    end

    defp validate_association(%{changes: %{owner_type: owner_type}} = changeset) do
        if owner_type not in ["admin"] do
            add_error(changeset, :owner_type, "is not a valid owner type")
        end
    end

    defp validate_association(changeset),
        do: changeset

      @doc false
    @spec update_changeset(Organization.t(), %{}) :: Organization.t()
    def update_changeset(organization, attrs) do
        organization |> cast(attrs, [:name, :owner_id, :owner_type])
    end
end

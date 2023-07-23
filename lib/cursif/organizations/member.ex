defmodule Cursif.Organizations.Member do
    use Ecto.Schema
    import Ecto.Changest

    alias Cursif.Organizations.Organization
    alias Cursif.Accounts.User

    @type t :: %__MODULE__{
        organization: Organization.t(),
        user: User.t(),

        # Timestamps
        inserted_at: any(),
        updated_at: any()
    }

    schema "members" do
        belongs_to :organization, Organization
        belongs_to :user, User

        timestamps()
    end

    @doc false
    @spec changeset(Member.t(), %{}) :: Member.t()
    def changeset(member, attrs) do
        member
        |> cast(attrs, [:organization_id, :user_id])
        |> validate_required([:organization_id, :user_id])
    end
end
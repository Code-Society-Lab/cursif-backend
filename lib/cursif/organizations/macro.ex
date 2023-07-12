defmodule Cursif.Organizations.Macro do
    use Ecto.Schema

    alias Cursif.Organizations.Member
    alias Cursif.Accounts.User

    @type t :: %__MODULE__{
                title: String.t(),
                pattern: String.t(),
                code: String.t(),
                member: Member.t(),

                # Timestamps
                inserted_at: any(),
                updated_at: any()
            }

    @primary_key {:id, :binary_id, autogenerate: true}
    @foreign_key_type :binary_id
    schema "macros" do
        field :title, :string
        field :pattern, :string
        field :code, :string
        
        has_many :member, Member, join_through: User

        timestamps()
    end
end

defmodule CursifWeb.Schema.OrganizationTypes do
    @moduledoc """
    The Organization types.
    """
    use Absinthe.Schema.Notation
    alias CursifWeb.Resolvers.Organizations

    @desc "Represents an organization"
    # Define the :member object type
    object :member do
        field :id, :string
        field :user, :partial_user
    end

    # Define the :name object type
    object :name do
        field :name, :string
    end

    object :organization do
        field :name, :string
        field :members, list_of(:member)
        field :notebooks, list_of(:notebook)
    end

    @desc "Organization queries"
    object :organization_queries do
        @desc "Get the list of organizations"
        field :organizations, list_of(:organization) do
            resolve(&Organizations.list_organizations/2)
        end

        @desc "Get a organization by name"
        field :organization, :organization do
            arg(:name, non_null(:string))
            resolve(&Organizations.get_organization_by_name/2)
        end
    end

    # Mutation objects
    object :organization_mutations do
        @desc "Create an organization"
        field :create_organization, :organization do
        arg(:name, non_null(:string))
        arg(:owner_id, non_null(:id))

        resolve(&Organizations.create_organization/2)
        end
    end
end
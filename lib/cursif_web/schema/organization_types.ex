defmodule CursifWeb.Schema.OrganizationTypes do
    @moduledoc """
    The Organization types.
    """
    use Absinthe.Schema.Notation
    alias CursifWeb.Resolvers.Organizations
    alias CursifWeb.Resolvers.Accounts

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
        field :id, :id
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

        @desc "Get a specific organization by id"
        field :organization_id, :organization do
            arg(:id, non_null(:id))
            resolve(&Organizations.get_by_id/2)
        end

        @desc "Get a specific user by id"
        field :user_id, :member do
            arg(:id, non_null(:id))
            resolve(&Accounts.get_user_by_id/2)
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

        @desc "Update an organization"
        field :update_organization, :organization do
            arg(:id, non_null(:id))  
            arg(:member, :string)

            resolve(&Organizations.update_organization/2)
        end

        @desc "Delete an organization"
        field :delete_organization, :organization do
            arg(:id, non_null(:id))

            resolve(&Organizations.delete_organization/2)
        end

        @desc "Create a member"
        field :create_member, :organization do
            arg(:id, non_null(:id))
            arg(:user_id, non_null(:id))
            resolve(&Organizations.create_member/2)
        end

        @desc "Add a member to the organization"
        field :add_member, :organization do
            arg(:organization_id, non_null(:id))
            arg(:user_id, non_null(:id))
            resolve(&Organizations.add_member/2)
        end
    end
end
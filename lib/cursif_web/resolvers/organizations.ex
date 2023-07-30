defmodule CursifWeb.Resolvers.Organizations do
    alias Cursif.Organizations
    alias Cursif.Organizations.Organization
  
    @spec list_organizations(map(), map()) :: {:ok, list(Organization.t())}
    def list_organizations(_args, _context) do
      {:ok, Organizations.list_organizations()}
    rescue _ ->
      {:error, :not_found}
    end

    @spec get_organization_by_name(map(), map()) :: {:ok, Organization.t()}
    def get_organization_by_name(%{name: name}, _context) do
      org = Organizations.get_by_name(name)
      IO.inspect(org)
      {:ok, org}
    rescue _ ->
        {:error, :not_found}
    end
  
    @spec create_organization(map(), map()) :: {:ok, Organization.t()}
    def create_organization(organization, _context) do
      case Organizations.create_organization(organization) do
        {:ok, organization} -> {:ok, organization}
        {:error, changeset} -> {:error, changeset}
      end
    end
  end
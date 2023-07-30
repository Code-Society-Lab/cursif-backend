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
      {:ok, Organizations.get_by_name(name)}
    rescue error ->
      Phoenix.log(error)
      {:error, :not_found}
    end

    @spec get_by_id(map(), map()) :: {:ok, Organization.t()}
    def get_by_id(%{id: id}, _context) do
      {:ok, Organizations.get_by_id!(id)}
    rescue error ->
      Phoenix.log(error)
      {:error, :not_found}
    end
  
    @spec create_organization(map(), map()) :: {:ok, Organization.t()}
    def create_organization(organization, _context) do
      case Organizations.create_organization(organization) do
        {:ok, organization} -> {:ok, organization}
        {:error, changeset} -> {:error, changeset}
      end
    end

    @spec update_organization(map(), map()) :: {:ok, Organization.t()} | {:error, atom()}
    def update_organization(%{id: id} = args, _context) do
      organization = Organizations.get_by_id!(id)

      case Organizations.update_organization(organization, args) do
        {:ok, organization} -> {:ok, organization}
        {:error, changeset} -> {:error, changeset}
      end
    end
  end
defmodule Cursif.Organizations do
  @moduledoc """
  The Organization context.
  """

  import Ecto.Query, warn: false
  alias Cursif.Repo
  alias Cursif.Organizations.Organization

  @doc """
  Returns the list of organizations.
  """
  def list_organizations do
    Repo.all(Organization) |> Repo.preload(:members)
  end

  @doc """
  Gets an Organization
  """
  def get_organization!(name), do: Repo.get!(Organization, name)

  @doc """
  Gets an Organization by its name
  """
  def get_by_name(name), do: Repo.get_by(Organization, name: name) |> Repo.preload([members: [:user], notebooks: [:pages]])

    @doc """
  Gets an Organization by its id
  """
  def get_by_id!(id), do: Repo.get!(Organization, id) |> Repo.preload([members: [:user], notebooks: [:pages]])


  @doc """
  Creates an organization.
  """
  @spec create_organization(map()) :: {:ok, Organization.t()} | {:error, %Ecto.Changeset{}}
  def create_organization(attrs) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an organization
  """
  @spec update_organization(Organization.t(), map()) :: {:ok, Organization.t()} | {:error, %Ecto.Changeset{}}
  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an organization.
  """
  @spec delete_organization(Organization.t()) :: {:ok, Organization.t()} | {:error, %Ecto.Changeset{}}
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  @doc """
  Returns the owner of an organization.
  """
  def get_owner!(%{owner_id: owner_id}) do
    Repo.get!(User, owner_id)
  end
end

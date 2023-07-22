defmodule Cursif.Organizations do
  @moduledoc """
  The Organization context.
  """

  import Ecto.Query, warn: false
  alias Cursif.Repo

  alias Cursif.Organizations.Organization

  @doc """
  Gets an Organization
  """
  @spec get_organization!(binary()) :: Organization.t()
  def get_organization!(id), do: Repo.get!(Organization, id) |> Repo.preload([:name, :member])

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
    |> Page.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an organization.
  """
  @spec delete_organization(Organization.t()) :: {:ok, Organization.t()} | {:error, %Ecto.Changeset{}}
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end
end

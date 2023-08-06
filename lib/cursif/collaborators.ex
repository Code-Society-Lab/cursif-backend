defmodule Cursif.Collaborators do
    @moduledoc """
    The Collaborator context.
    """
  
    import Ecto.Query, warn: false
    alias Cursif.Repo
    alias Cursif.Notebooks.Collaborator

    @doc """
    Returns the list of collaborators
    """
    def list_collaborators do
      Repo.all(Collaborator) |> Repo.preload(:notebook)
    end

    @doc """
    Gets a collaborator
    """
    def get_collaborator!(id), do: Repo.get!(Collaborator, id) |> Repo.preload(:notebook)

    @doc """
    Creates a collaborator.
  
    """
  @spec create_collaborator(map()) :: {:ok, Collaborator.t()} | {:error, %Ecto.Changeset{}}
    def create_collaborator(attrs) do
      %Collaborator{}
      |> Collaborator.changeset(attrs)
      |> Repo.insert()
    end
  
    @doc """
    Updates a collaborator.
  
    """
    @spec update_collaborator(Collaborator.t(), map()) :: {:ok, Collaborator.t()} | {:error, %Ecto.Changeset{}}
    def update_collaborator(%Collaborator{} = collaborator, attrs) do
      collaborator
      |> Collaborator.changeset(attrs)
      |> Repo.update()
    end
  
    @doc """
    Deletes a collaborator.
  
    """
    def delete_collaborator(%Collaborator{} = collaborator) do
      Repo.delete(collaborator)
    end
  end
  
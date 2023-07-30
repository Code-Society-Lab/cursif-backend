defmodule Cursif.Notebooks do
  @moduledoc """
  The Notebooks context.
  """

  import Ecto.Query, warn: false
  alias Cursif.Repo

  alias Cursif.Notebooks.Notebook

  @doc """
  Returns the list of notebooks.

  ## Examples

      iex> list_notebooks()
      [%Notebook{}, ...]

  """
  def list_notebooks do
    Repo.all(Notebook) |> Repo.preload(:pages)
  end

  @doc """
  Gets a single notebook.

  Raises `Ecto.NoResultsError` if the Notebook does not exist.

  ## Examples

      iex> get_notebook!(123)
      %Notebook{}

      iex> get_notebook!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notebook!(id), do: Repo.get!(Notebook, id) |> Repo.preload(pages: [:children, :author])

  @doc """
  Creates a notebook.

  ## Examples

      iex> create_notebook(%{field: value})
      {:ok, %Notebook{}}

      iex> create_notebook(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notebook(attrs \\ %{}) do
    %Notebook{}
    |> Notebook.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a notebook.

  ## Examples

      iex> update_notebook(notebook, %{field: new_value})
      {:ok, %Notebook{}}

      iex> update_notebook(notebook, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_notebook(Notebook.t(), map()) :: {:ok, Notebook.t()} | {:error, %Ecto.Changeset{}}
  def update_notebook(%Notebook{} = notebook, attrs) do
    notebook
    |> Notebook.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a notebook.

  ## Examples

      iex> delete_notebook(notebook)
      {:ok, %Notebook{}}

      iex> delete_notebook(notebook)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notebook(%Notebook{} = notebook) do
    Repo.delete(notebook)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notebook changes.

  ## Examples

      iex> change_notebook(notebook)
      %Ecto.Changeset{data: %Notebook{}}

  """
  def change_notebook(%Notebook{} = notebook, attrs \\ %{}) do
    Notebook.changeset(notebook, attrs)
  end

  @doc """
  Returns the owner of a notebook.

  ## Examples

      iex> get_owner!(%{owner_id: owner_id, owner_type: "user"})
      %User{}
  """
  def get_owner!(%{owner_id: owner_id, owner_type: "user"}) do
    Repo.get!(User, owner_id)
  end

  def get_owner!(%{owner_id: owner_id, owner_type: "organization"}) do
    Repo.get!(Organizations, owner_id)
  end
end

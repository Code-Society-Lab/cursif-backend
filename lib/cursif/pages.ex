defmodule Cursif.Pages do
  @moduledoc """
  The Pages context.
  """

  import Ecto.Query, warn: false
  alias Cursif.Repo

  alias Cursif.Notebooks
  alias Cursif.Notebooks.{Notebook, Page, Policy}

  defdelegate authorize(action, user, params), to: Policy

  @doc """
  Gets a single page.

  ## Examples

      iex> get_page!(123)
      %Page{}

      iex> get_page!(456)
      ** (Ecto.NoResultsError)
  """
  @spec get_page!(binary()) :: Page.t()
  def get_page!(id),
    do: Repo.get!(Page, id) |> Repo.preload([:author, :children])

  @doc """
  Creates a page.

  ## Examples

      iex> create_page(%{field: value})
      {:ok, %Page{}}

      iex> create_page(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  @spec create_page(map()) :: {:ok, Page.t()} | {:error, %Ecto.Changeset{}}
  def create_page(attrs) do
    %Page{}
    |> Page.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a page

  ## Examples

      iex> update_page(page, %{field: new_value})
      {:ok, %Page{}}

      iex> update_page(page, %{field: bad_value})
      {:error, %Ecto.Changeset()}
  """
  @spec update_page(Page.t(), map()) :: {:ok, Page.t()} | {:error, %Ecto.Changeset{}}
  def update_page(%Page{} = page, attrs) do
    page
    |> Page.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a page.

  ## Examples

      iex> delete_page(page)
      {:ok, %Page{}}

      iex> delete_page(page)
      {:error, %Ecto.Changeset{}}
  """
  @spec delete_page(Page.t()) :: {:ok, Page.t()} | {:error, %Ecto.Changeset{}}
  def delete_page(%Page{} = page) do
    Repo.delete(page)
  end

  @doc """
  Gets a page's parent.

  ## Examples

      iex> get_parent!(%Page{})
      %Page{}

      iex> get_parent!(%Page{})
      ** (RuntimeError)

  """
  @spec get_parent!(Page.t()) :: Page.t() | Notebook.t() | {:error, String.t()}
  def get_parent!(%Page{} = page) do
    case page.parent_type do
      "notebook"
        -> Notebooks.get_notebook!(page.parent_id)
      "page"
        -> get_page!(page.parent_id)
      _
        -> raise "Invalid parent type"
    end
  end

  @doc """
  Checks if the user is the owner of the notebook

  ## Examples

    iex> owner?(notebook, user)
    true

    iex> owner?(notebook, user)
    false

  """
  @spec owner?(Page.t(), User.t()) :: boolean()
  def owner?(page, user) do
    parent = get_parent!(page)

    case parent do
      %Notebook{} -> Notebooks.owner?(parent, user)
      %Page{} -> owner?(parent, user)
    end
  end

  @doc """
  Checks if the user is a collaborator of the notebook

  ## Examples

    iex> collaborator?(notebook, user)
    true

    iex> collaborator?(notebook, user)
    false

  """
  @spec collaborator?(Page.t(), User.t()) :: boolean()
  def collaborator?(page, user) do
    parent = get_parent!(page)

    case parent do
      %Notebook{} -> Notebooks.collaborator?(parent, user)
      %Page{} -> collaborator?(parent, user)
    end
  end
end

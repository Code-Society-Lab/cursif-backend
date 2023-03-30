defmodule Cursif.Pages do
  @moduledoc """
  The Pages context.
  """

  import Ecto.Query, warn: false
  alias Cursif.Repo

  alias Cursif.Pages.Page

  @doc """
  Gets a single page.

  ## Examples

      iex> get_page!(123)
      %Page{}

      iex> get_page!(456)
      ** (Ecto.NoResultsError)
  """
  @spec get_page!(binary()) :: Page.t()
  def get_page!(id), do: Repo.get!(Page, id) |> Repo.preload([:author, :children])

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
    |> Page.changeset(attrs)
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
end

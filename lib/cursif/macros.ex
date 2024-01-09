defmodule Cursif.Macros do
  @moduledoc """
  The Macro context.
  """

  import Ecto.Query, warn: false

  alias Cursif.Repo
  alias Cursif.Notebooks.{Notebook, Macro}

  @doc """
  Returns the list of macros

  ## Examples

      iex> list_macros()
      [%Macro{}, ...]
  """
  def list_macros,
    do: Repo.all(Macro) |> Repo.preload(:notebook)

  @doc """
  Gets a Macro

  ## Examples

      iex> get_macro!(id)
      %Macro{}

      iex> get_macro!(id)
      ** (Ecto.NoResultsError)

  """
  def get_macro!(id),
    do: Repo.get!(Macro, id) |> Repo.preload(:notebook)

  @doc """
  Creates a macro.

  ## Examples

      iex> create_macro(attrs)
      {:ok, %Macro{}}

      iex> create_macro(attrs)
      {:error, %Ecto.Changeset{}}

  """
  def create_macro(attrs \\ %{}) do
    %Macro{}
    |> Macro.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a macro.

  ## Examples

      iex> update_macro(macro, attrs)
      {:ok, %Macro{}}

      iex> update_macro(macro, attrs)
      {:error, %Ecto.Changeset{}}

  """
  @spec update_macro(Macro.t(), map()) :: {:ok, Macro.t()} | {:error, %Ecto.Changeset{}}
  def update_macro(%Macro{} = macro, attrs) do
    macro
    |> Macro.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a macro.

  ## Examples

      iex> delete_macro(macro)
      {:ok, %Macro{}}

      iex> delete_macro(macro)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_macro(Macro.t()) :: {:ok, Macro.t()} | {:error, %Ecto.Changeset{}}
  def delete_macro(%Macro{} = macro),
    do: Repo.delete(macro)

  @doc """
  Gets the notebook for a given macro.

  ## Examples

      iex> get_notebook(macro)
      {:ok, %Notebook{}}

      iex> get_notebook(macro)
      {:error, %Ecto.Changeset{}}

  """
  @spec get_notebook!(Macro.t()) :: {:ok, Notebook.t()} | {:error, %Ecto.Changeset{}}
  def get_notebook!(%{id: macro_id}) do
    query = from n in Notebook,
      left_join: m in Macro, on: n.id == m.notebook_id,
      where: m.id == ^macro_id,
      select: n

    Repo.one(query)
  end
end
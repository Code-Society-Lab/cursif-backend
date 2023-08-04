defmodule Cursif.Macros do
    @moduledoc """
    The Macro context.
    """
  
    import Ecto.Query, warn: false
    alias Cursif.Repo
    alias Cursif.Notebooks.Macro

    @doc """
    Returns the list of macros
    """
    def list_macros do
      Repo.all(Macro) |> Repo.preload(:notebook)
    end

    @doc """
    Gets a Macro
    """
    def get_macro!(id), do: Repo.get!(Macro, id) |> Repo.preload(:notebook)

    @doc """
    Creates a macro.
  
    """
    def create_macro(attrs \\ %{}) do
      %Macro{}
      |> Macro.changeset(attrs)
      |> Repo.insert()
    end
  
    @doc """
    Updates a macro.
  
    """
    @spec update_macro(Macro.t(), map()) :: {:ok, Macro.t()} | {:error, %Ecto.Changeset{}}
    def update_macro(%Macro{} = macro, attrs) do
      macro
      |> Macro.changeset(attrs)
      |> Repo.update()
    end
  
    @doc """
    Deletes a macro.
  
    """
    def delete_macro(%Macro{} = macro) do
      Repo.delete(macro)
    end
  end
  
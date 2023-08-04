defmodule CursifWeb.Resolvers.Macros do
    alias Cursif.Macros
    alias Cursif.Notebooks.Macro

    @spec list_macros(map(), map()) :: {:ok, list(Macro.t())}
    def list_macros(_args, _context) do
        {:ok, Macros.list_macros()}
    rescue _ ->
        {:error, :not_found}
    end

    @spec get_macro_by_id(map(), map()) :: {:ok, Macro.t()}
    def get_macro_by_id(%{id: id}, _context) do
      {:ok, Macros.get_macro!(id)}
    rescue _ ->
      {:error, :not_found}
    end

    @spec create_macro(map(), map()) :: {:ok, Macro.t()}
    def create_macro(macro, _context) do
        case Macros.create_macro(macro) do
            {:ok, macro} -> {:ok, macro}
            {:error, changeset} -> {:error, changeset}
        end
    end

    @spec update_macro(map(), map()) :: {:ok, Macro.t()} | {:error, atom()}
    def update_macro(%{id: id} = args, _context) do
        macro = Macros.get_macro!(id)
      
        case Macros.update_macro(macro, args) do
            {:ok, macro} -> {:ok, macro}
            {:error, changeset} -> {:error, changeset}
        end
    end

    @spec delete_macro(map(), map()) :: {:ok, Macro.t()} | {:error, atom()}
    def delete_macro(%{id: id}, _context) do
        macro = Macros.get_macro!(id)

        case Macros.delete_macro(macro) do
            {:ok, macro} -> {:ok, macro}
            {:error, changeset} -> {:error, changeset}
        end
    end
end
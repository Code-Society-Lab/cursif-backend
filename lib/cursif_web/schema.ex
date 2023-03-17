defmodule CursifWeb.Schema do
  @moduledoc """
  Contains types query and mutation schema
  """

  use Absinthe.Schema
  alias CursifWeb.Schema.{AccountTypes, NotebookTypes}
  alias CursifWeb.Middlewares.{ErrorHandler, SafeResolution}

  import_types(AccountTypes)
  import_types(NotebookTypes)

  query do
    # Users
    import_fields(:user_queries)

    # Notebooks
    import_fields(:notebook_queries)
  end

  mutation do
    import_fields(:session_mutations)
  end

  def middleware(middleware, _field, %{identifier: type}) when type in [:query, :mutation] do
    SafeResolution.apply(middleware) ++ [ErrorHandler]
  end

  def middleware(middleware, _field, _object), do: middleware
end
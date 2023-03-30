defmodule CursifWeb.Schema do
  @moduledoc "Contains types query and mutation schema"

  use Absinthe.Schema
  alias CursifWeb.Schema.{AccountTypes, NotebookTypes, PageTypes}
  alias CursifWeb.Middlewares.{ErrorHandler, SafeResolution}

  import_types(AccountTypes)
  import_types(NotebookTypes)
  import_types(PageTypes)

  query do
    import_fields(:user_queries)
    import_fields(:notebook_queries)
    import_fields(:page_queries)
  end

  mutation do
    import_fields(:session_mutations)
    import_fields(:notebook_mutations)
    import_fields(:page_mutations)
  end

  def middleware(middleware, _field, %{identifier: type}) when type in [:query, :mutation] do
    SafeResolution.apply(middleware) ++ [ErrorHandler]
  end

  def middleware(middleware, _field, _object), do: middleware
end
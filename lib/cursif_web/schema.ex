defmodule CursifWeb.Schema do
  @moduledoc "Contains types query and mutation schema"

  use Absinthe.Schema
  alias CursifWeb.Schema.{AccountTypes, NotebookTypes, PageTypes}
  alias CursifWeb.Middlewares.{ErrorHandler, SafeResolution, Authentication}

  import_types(AccountTypes)
  import_types(NotebookTypes)
  import_types(PageTypes)

  @skip_authentication [
    :login,
    :register
  ]

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

  def middleware(middleware, field, %{identifier: type}) when type in [:query, :mutation, :subscription] do
    if field.identifier in @skip_authentication do
      default_middleware(middleware)
    else
      default_middleware([Authentication | middleware])
    end
  end

  def middleware(middleware, _field, _object),
      do: default_middleware(middleware)

  # Add the default middleware to the list of middleware.
  defp default_middleware(middleware),
       do: SafeResolution.apply(middleware ++ [ErrorHandler])
end
defmodule CursifWeb.Schema do
  @moduledoc """
  Contains types query and mutation schema
  """

  use Absinthe.Schema
  alias CursifWeb.Schema.AccountTypes
  alias CursifWeb.Schema.PageTypes
  alias CursifWeb.Middlewares.{ErrorHandler, SafeResolution}

  import_types(AccountTypes)
  import_types(PageTypes)

  query do
    import_fields(:list_users)
    import_fields(:get_user)
    import_fields(:get_me)

    # Pages
    import_fields(:page_queries)
  end

  mutation do
    import_fields(:login_mutation)
    import_fields(:register_mutation)

    # Pages
    import_fields(:page_mutations)
  end

  def middleware(middleware, _field, %{identifier: type}) when type in [:query, :mutation] do
    SafeResolution.apply(middleware) ++ [ErrorHandler]
  end

  def middleware(middleware, _field, _object), do: middleware
end

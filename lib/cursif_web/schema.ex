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

    import_fields(:get_page)
  end

  mutation do
    import_fields(:login_mutation)
    import_fields(:register_mutation)

    import_fields(:create_mutation)
  end

  def middleware(middleware, _field, %{identifier: type}) when type in [:query, :mutation] do
    SafeResolution.apply(middleware) ++ [ErrorHandler]
  end

  def middleware(middleware, _field, _object), do: middleware
end

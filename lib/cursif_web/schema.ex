defmodule CursifWeb.Schema do
  @moduledoc """
  Contains types query and mutation schema
  """

  use Absinthe.Schema
  alias CursifWeb.Schema.AccountTypes

  import_types(AccountTypes)

  query do
    import_fields(:list_users)
    import_fields(:get_user)
    import_fields(:get_me)
  end

  mutation do
    import_fields(:login_mutation)
    import_fields(:register_mutation)
  end

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [CursifWeb.Middlewares.ChangesetErrorHandler]
  end

  def middleware(middleware, _field, _object), do: middleware
end
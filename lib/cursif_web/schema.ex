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
    import_fields(:list_users)
    import_fields(:get_user)
    import_fields(:get_me)

    # Notebooks
    import_fields(:list_notebooks)
  end

  mutation do
    # Users
    import_fields(:login_mutation)
    import_fields(:register_mutation)
  end

  def middleware(middleware, _field, %{identifier: type}) when type in [:query, :mutation] do
    SafeResolution.apply(middleware) ++ [ErrorHandler]
  end

  def middleware(middleware, _field, _object), do: middleware
end
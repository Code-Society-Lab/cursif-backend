defmodule CursifWeb.Schema do
  @moduledoc """
  Contains types query and mutation schemas
  """

  use Absinthe.Schema
  alias CursifWeb.Schemas

  import_types(Schemas.UserTypes)

  query do
    import_fields(:get_users)
    import_fields(:get_user)
  end
end
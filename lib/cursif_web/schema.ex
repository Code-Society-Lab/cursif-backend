defmodule CursifWeb.Schema do
  @moduledoc """
  Contains types query and mutation schema
  """

  use Absinthe.Schema
  alias CursifWeb.Schema.{UserTypes}

  import_types(UserTypes)

  query do
    import_fields(:get_users)
    import_fields(:get_user)
  end
end
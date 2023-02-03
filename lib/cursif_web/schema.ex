defmodule CursifWeb.Schema do
  @moduledoc """
  Contains types query and mutation schema
  """

  use Absinthe.Schema
  alias CursifWeb.Schema.UserTypes

  import_types(UserTypes)

  query do
    import_fields(:get_users)
    import_fields(:get_user)
    import_fields(:get_me)
  end

  mutation do
    import_fields(:login_mutation)
    import_fields(:register_mutation)
  end
end
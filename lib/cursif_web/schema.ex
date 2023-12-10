defmodule CursifWeb.Schema do
  @moduledoc """
  This module serves as an orchestrator, seamlessly integrating queries, mutations, 
  and subscriptions for various schemas. Its primary function is to streamline the process 
  of incorporating new schemas while ensuring a consistent behavior across all schemas.

  # Add a Schema

  - Create a schema module in the `schemas` folder. Define queries, 
    mutations, and required components.
  - Additional custom types should have separate modules in `schemas/types`. Use `import_types/1` 
    to add your types to the schema.
  - Import your schama with import_types/1 and your queries, mutations, and subscriptions with 
    import_fields/1.

  ### Example:
  ```elixir
  defmodule CursifWeb.Schemas.User do
    use Absinthe.Schema.Notation

    object :user_queries do
      ...
    end

    object :user_mutations do
      ...
    end

    ...
  end
  ```
  
  ## Handling Large Schemas

  If your schema becomes large due to a substantial number of queries, mutations, or 
  subscriptions, consider organizing your code by placing each individual section into its 
  respective query, mutation, or subscription module.

  use `import_types` from you shchema to import all queries, mutations, and subscriptions

  ### Example:

  ```elixir
  defmodule CursifWeb.Schemas.User do
    use Absinthe.Schema.Notation

    import_types(CursifWeb.Schemas.UserTypes)

    import_types(CursifWeb.Schemas.UserQueries)
    import_types(CursifWeb.Schemas.UserMutations)
    import_types(CursifWeb.Schemas.UserSubscriptions)
  end
  ```

  # Middleware and Authentication

  Middleware handling, particularly authentication, is an integral part of the schema. 
  Authentication middleware is applied selectively based on the nature of the field being accessed. 
  Fields listed in the @skip_authentication attribute are exempt from authentication checks.
  """
  use Absinthe.Schema
  alias CursifWeb.Middlewares.{SafeResolution, Authentication}
  
  # Add types here
  import_types(CursifWeb.Schemas.{
    AccountTypes, 
    NotebookTypes, 
    PageTypes,
  })

  # Add schemas here
  import_types(CursifWeb.Schemas.{
    Account, 
    Notebook, 
    Page,
  })

  @skip_authentication [
    :login,
    :register,
    :confirm,
    :resend_confirmation_email,
    :send_reset_password_token,
    :reset_password,
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

  # subscriptions do
  #   import_fields(:your_subscription)
  # end

  def middleware(middleware, field, %{identifier: type}) when type in [:query, :mutation, :subscription] do
    if field.identifier in @skip_authentication do
      default_middleware(middleware)
    else
      default_middleware([Authentication, Speakeasy.Authn | middleware])
    end
  end

  def middleware(middleware, _field, _object),
    do: default_middleware(middleware)

  # Add the default middleware to the list of middleware.
  defp default_middleware(middleware),
    do: SafeResolution.apply(middleware)
end
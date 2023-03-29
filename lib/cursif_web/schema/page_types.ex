defmodule CursifWeb.Schema.PageTypes do
  @moduledoc """
  The page types.
  """

  use Absinthe.Schema.Notation
  alias CursifWeb.Resolvers.Pages

  @desc "A page"
  object :page do
    field :id, :id
    field :title, :string
    field :contents, :string
  end

  object :get_page do
    @desc "Get a specific page by id"

    field :page, :page do
      arg(:id, non_null(:id))

      resolve(&Pages.get_page_by_id/2)
    end
  end

  # Mutation objects
  object :create_mutation do
    @desc """
    create page
    """

    @desc "Create a page"
    field :create_page, :page do
      arg(:title, non_null(:string))
      arg(:contents, :string)

      resolve(&Pages.create_page/2)
    end
  end
end

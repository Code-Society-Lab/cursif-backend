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
    field :content, :string
    field :author, :user
    field :parent_id, :id
    field :parent_type, :string
    field :children, list_of(:page)
  end

  @desc "Page queries"
  object :page_queries do
    @desc "Get a specific page by id"
    field :page, :page do
      arg(:id, non_null(:id))

      resolve(&Pages.get_page_by_id/2)
    end
  end

  # Mutation objects
  object :page_mutations do
    @desc "Create a page"
    field :create_page, :page do
      arg(:title, non_null(:string))
      arg(:content, :string)
      arg(:parent_id, non_null(:id))
      arg(:parent_type, non_null(:string))

      resolve(&Pages.create_page/2)
    end
  end
end

defmodule CursifWeb.Schemas.Page do
  @moduledoc "Contains types for pages"

  use Absinthe.Schema.Notation
  alias CursifWeb.Resolvers.Pages

  @desc "Collection of queries"
  object :page_queries do
    @desc "Get a specific page by id"
    field :page, :page do
      arg(:id, non_null(:id))

      resolve(&Pages.get_page_by_id/2)
    end
  end

  @desc "Collection of mutations"
  object :page_mutations do
    field :create_page, :page do
      arg(:title, non_null(:string))
      arg(:content, :string)
      arg(:parent_id, non_null(:id))
      arg(:parent_type, non_null(:string))

      resolve(&Pages.create_page/2)
    end

    field :update_page, :page do
      arg(:id, non_null(:id))
      arg(:title, :string)
      arg(:content, :string)
      arg(:parent_id, :id)
      arg(:parent_type, :string)

      resolve(&Pages.update_page/2)
    end
  end
end

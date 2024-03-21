defmodule CursifWeb.Schemas.Page do
  @moduledoc "Contains types for pages"

  use Absinthe.Schema.Notation
  alias CursifWeb.Resolvers.Pages

  @desc "Collection of queries"
  object :page_queries do
    @desc "Get a specific page by id"
    field :page, :page do
      arg(:id, non_null(:id))

      middleware Speakeasy.LoadResource, &Cursif.Pages.get_parent!/1
      middleware Speakeasy.Authz, {Cursif.Pages, :collaborator}

      resolve(&Pages.get_page_by_id/2)
    end
  end

  @desc "Collection of mutations"
  object :page_mutations do

    @desc "Create a page"
    field :create_page, :page do
      arg(:title, non_null(:string))
      arg(:content, :string)
      arg(:parent_id, non_null(:id))
      arg(:parent_type, non_null(:string))

      middleware Speakeasy.LoadResource, fn(attrs) ->
        Cursif.Pages.get_parent!(%{parent_id: attrs.parent_id, parent_type: attrs.parent_type})
      end
      middleware Speakeasy.Authz, {Cursif.Pages, :collaborator}

      resolve(&Pages.create_page/2)
    end

    @desc "Update a page"
    field :update_page, :page do
      arg(:id, non_null(:id))
      arg(:title, :string)
      arg(:content, :string)
      arg(:parent_id, :id)
      arg(:parent_type, :string)

      middleware Speakeasy.LoadResource, &Cursif.Pages.get_parent!/1
      middleware Speakeasy.Authz, {Cursif.Pages, :collaborator}

      resolve(&Pages.update_page/2)
    end

    @desc "Delete a page"
    field :delete_page, :page do
      arg(:id, non_null(:id))

      resolve(&Pages.delete_page/2)
    end
  end
end

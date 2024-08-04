defmodule CursifWeb.Schemas.Page do
  @moduledoc "Contains types for pages"

  use Absinthe.Schema.Notation

  alias CursifWeb.Resolvers.Pages

  @desc "Collection of queries"
  object :page_queries do
    @desc "Get a specific page by id"
    field :page, :page do
      arg(:id, non_null(:id))

      middleware Speakeasy.LoadResourceByID, &Pages.get_page_by_id/1
      middleware Speakeasy.Authz, {Cursif.Pages, :collaborator}

      resolve(&Pages.get_page_by_id/2)
    end
  end

  @desc "Collection of mutations"
  object :page_mutations do

    field :create_page, :page do
      arg(:title, non_null(:string))
      arg(:content, :string, default_value: "")
      arg(:parent_id, non_null(:id))
      arg(:parent_type, :string, default_value: "notebook")

      middleware Speakeasy.LoadResource, fn(params) ->
        if params.parent_type == "page" do
          Pages.get_page_by_id(params.parent_id)
        else
          Cursif.Notebooks.get_notebook!(params.parent_id)
        end
      end
      middleware Speakeasy.Authz, {Cursif.Pages, :collaborator}

      resolve(&Pages.create_page/2)
    end

    field :update_page, :page do
      arg(:id, non_null(:id))
      arg(:title, :string)
      arg(:content, :string)

      middleware Speakeasy.LoadResourceByID, &Pages.get_page_by_id/1
      middleware Speakeasy.Authz, {Cursif.Pages, :collaborator}

      resolve(&Pages.update_page/2)
    end

    @desc "Delete a page"
    field :delete_page, :page do
      arg(:id, non_null(:id))

      middleware Speakeasy.LoadResourceByID, &Pages.get_page_by_id/1
      middleware Speakeasy.Authz, {Cursif.Pages, :collaborator}

      resolve(&Pages.delete_page/2)
    end
  end

  @desc "Collection of subscriptions"
  object :page_subscriptions do
    field :page_updated, :page do
      arg(:id, non_null(:id))

      config fn args, _info ->
        {:ok, topic: args.id}
      end

      trigger :update_page, topic: fn page ->
        page.id
      end

      resolve fn page, _, _ ->
        {:ok, page}
      end
    end
  end
end

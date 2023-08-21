defmodule CursifWeb.Schemas.PageTypes do
  @moduledoc "Contains types for pages"

  use Absinthe.Schema.Notation
  alias CursifWeb.Resolvers.Pages

  union :parent do
    types [:page, :notebook]
    resolve_type(&Pages.get_parent/2)
  end

  object :page do
    field :id, :id
    field :title, :string
    field :content, :string
    field :author, :user
    field :parent_id, :id
    field :parent_type, :string
    field :parent, :parent
    field :children, list_of(:page)
  end
end

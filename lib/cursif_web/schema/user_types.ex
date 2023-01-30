defmodule CursifWeb.Schema.UserTypes do
  @moduledoc """
  The User types.
  """

  use Absinthe.Schema.Notation
  alias CursifWeb.Resolvers

  @desc "A user"
  object :user do
    field :id, :id
    field :username, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
  end

  object :get_users do
    @desc """
    Get a list of users
    """

    field :users, list_of(:user) do
      resolve(&Resolvers.Users.get_users/2)
    end
  end

  object :get_user do
    @desc """
    Get a user
    """

    field :user, :user do
      arg(:id, non_null(:id))

      resolve(&Resolvers.Users.get_user!/2)
    end
  end
end
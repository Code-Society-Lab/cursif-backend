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

  @desc "session value"
  object :session do
    field(:token, :string)
    field(:user, :user)
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

  # Mutation objects
  object :register_mutation do
    @desc """
    create user
    """

    @desc "Create a user"
    field :register, :user do
      arg(:username, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Users.register/3)
    end
  end

  object :login_mutation do
    @desc """
    login with the params
    """

    field :login, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Users.login/2)
    end
  end
end
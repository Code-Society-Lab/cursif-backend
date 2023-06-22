defmodule CursifWeb.Schema.AccountTypes do
  @moduledoc """
  The types associated with an account.
  """

  use Absinthe.Schema.Notation
  alias CursifWeb.Resolvers.Accounts

  @desc "Represents a partial user"
  object :partial_user do
    field :id, :id
    field :username, :string
  end

  @desc "Represents a user"
  object :user do
    field :id, :id
    field :username, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
  end

  @desc "Represents a session"
  object :session do
    field(:token, :string)
    field(:user, :user)
  end

  @desc "Session mutations"
  object :session_mutations do
    @desc "Create a user"
    field :register, :user do
      arg(:username, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Accounts.register/2)
    end

    @desc "Login with the params"
    field :login, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Accounts.login/2)
    end
  end

  @desc "User queries"
  object :user_queries do

    @desc "Get a list of users"
    field :users, list_of(:partial_user) do
      resolve(&Accounts.list_users/2)
    end

    field :user, :partial_user do
      arg(:id, non_null(:id))
      resolve(&Accounts.get_user_by_id/2)
    end

    field :me, :user do
      resolve(&Accounts.get_current_user/2)
    end
  end
end
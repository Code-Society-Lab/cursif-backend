defmodule CursifWeb.Schemas.Account do
  @moduledoc """
  The types associated with an account.
  """

  use Absinthe.Schema.Notation

  alias CursifWeb.Resolvers.Accounts

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

  object :session_mutations do
    @desc "Create a user"
    field :register, :user do
      arg(:first_name, :string)
      arg(:last_name, :string)
      arg(:username, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      arg(:language_id, :integer)
      arg(:theme_id, :integer)

      resolve(&Accounts.register/2)
    end

    @desc "Update a user"
    field :update_user, :user do
      arg(:id, non_null(:id))
      arg(:email, :string)
      arg(:username, :string)
      arg(:first_name, :string)
      arg(:last_name, :string)
      arg(:language_id, :integer)
      arg(:theme_id, :integer)

      resolve(&Accounts.update_user/2)
    end

    @desc "Login with the params"
    field :login, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Accounts.login/2)
    end

    @desc "Confirm a user's account"
    field :confirm, :string do
      arg(:token, non_null(:string))

      resolve(&Accounts.confirm/2)
    end

    @desc "Resend a confirmation email"
    field :resend_confirmation_email, :string do
      arg(:email, non_null(:string))

      resolve(&Accounts.resend_confirmation_email/2)
    end

    @desc "Reset user's password"
    field :reset_password, :string do
      arg(:password, non_null(:string))
      arg(:token, non_null(:string))

      resolve(&Accounts.reset_password/2)
    end

    @desc "Send a token to reset user's password"
    field :send_reset_password_token, :string do
      arg(:email, non_null(:string))

      resolve(&Accounts.send_reset_password_token/2)
    end
  end
end

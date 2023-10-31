defmodule CursifWeb.Schemas.AccountTypes do
  @moduledoc """
  The types associated with an account.
  """

  use Absinthe.Schema.Notation

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
    field :token, :string
    field :user, :user
  end
end

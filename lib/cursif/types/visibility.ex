defmodule Cursif.Visibility do
  @moduledoc """
  The Visibility type.
  """

  use Ecto.Type

  visibilities = [
    :public,
    :private
  ]

  def type, do: :string

  for visibility <- visibilities do
    def cast(unquote(visibility)), do: {:ok, unquote(visibility)}
    def cast(unquote(to_string(visibility))), do: {:ok, unquote(visibility)}

    def load(unquote(visibility)), do: {:ok, unquote(visibility)}

    def dump(unquote(visibility)), do: {:ok, unquote(visibility)}
    def dump(unquote(to_string(visibility))), do: {:ok, unquote(visibility)}

    def cast(_other), do: :error
    def dump(_other), do: :error
  end
end
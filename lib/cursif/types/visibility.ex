defmodule Cursif.Visibility do
  @typedoc "The visibility of a notebook or page."
  @type visibility :: atom()

  use Ecto.Type

  visibilities = [
    :public,
    :private
  ]

  def type, do: :string

  def cast(visibility), do: {:ok, visibility}
  def load(visibility), do: {:ok, visibility}
  def dump(visibility), do: {:ok, visibility}
end
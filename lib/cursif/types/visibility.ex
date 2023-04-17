defmodule Cursif.Visibility do
  @typedoc "The visibility of a notebook or page."

  use Ecto.Type

  visibilities = [
    :public,
    :private
  ]

  def type, do: :string

  for visibility <- visibilities do
    def cast(visibility), do: {:ok, visibility}
    def load(visibility), do: {:ok, visibility}
    def dump(visibility), do: {:ok, visibility}
  end
end
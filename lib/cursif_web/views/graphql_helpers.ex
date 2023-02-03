defmodule CursifWeb.GraphqlHelpers do
  import CursifWeb.ErrorHelpers, only: [translate_error: 1]

  @doc """
  Translate ecto error into graphql errors
  """
  @spec translate_ecto_error(Ecto.Changeset.t()) :: list({:field, :message})
  def translate_ecto_error(changeset) do
    Enum.map(changeset.errors, fn {field, error} ->
      %{field: field, message: translate_error(error)}
    end)
  end
end
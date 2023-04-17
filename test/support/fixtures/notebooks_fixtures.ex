defmodule Cursif.NotebooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cursif.Notebooks` context.
  """

  @doc """
  Generate a notebook.
  """
  def notebook_fixture(attrs \\ %{}) do
    {:ok, notebook} =
      attrs
      |> Enum.into(%{
        title: "some title",
        description: "some description",
        visibility: "public",
      })
      |> Cursif.Notebooks.create_notebook()

    notebook
  end
end

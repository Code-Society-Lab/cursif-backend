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
        description: "some description",
        title: "some title"
      })
      |> Cursif.Notebooks.create_notebook()

    notebook
  end

  @doc """
  Generate a notebook.
  """
  def notebook_fixture(attrs \\ %{}) do
    {:ok, notebook} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title",
        visibility: "some visibility"
      })
      |> Cursif.Notebooks.create_notebook()

    notebook
  end
end

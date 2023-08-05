defmodule Cursif.NotebooksTest do
  use Cursif.DataCase

  import Cursif.{NotebooksFixtures, AccountsFixtures}

  alias Cursif.Notebooks
  alias Cursif.Notebooks.Notebook


  describe "notebooks" do

    setup do
      {:ok, user: user, password: _password} = create_unique_user()
      notebook = notebook_fixture(%{
        owner_type: "user",
        owner_id: user.id,
      })

      {:ok, user: user, notebook: notebook}
    end

    test "list_notebooks/1 returns all notebooks for a user", %{user: user, notebook: notebook} do
      notebook_ids = Notebooks.list_notebooks(user) |> Enum.map(& &1.id)
      assert notebook_ids == [notebook.id]
    end

    test "get_notebook!/1 returns the notebook with given id", %{notebook: notebook} do
      assert Map.take(Notebooks.get_notebook!(notebook.id), [:id, :title, :description]) ==
               Map.take(notebook, [:id, :title, :description])
    end

    test "create_notebook/1 with valid data creates a notebook", %{user: user} do
      attrs = %{
        title: "some title",
        description: "some description",
        owner_type: "user",
        owner_id: user.id,
      }

      assert {:ok, %Notebook{} = notebook} = Notebooks.create_notebook(attrs)
      assert notebook.description == "some description"
      assert notebook.title == "some title"
    end

    test "create_notebook/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notebooks.create_notebook(%{})
    end

    # Something might be wrong with the update_notebook function 
    test "update_notebook/2 with valid data updates the notebook", %{notebook: notebook} do
      update_attrs = %{title: "some updated title", description: "some updated description"}

      assert {:ok, %Notebook{} = notebook} = Notebooks.update_notebook(notebook, update_attrs)
      assert notebook.description == update_attrs.description
      assert notebook.title == update_attrs.title
    end

    test "update_notebook/2 with invalid data returns error changeset", %{notebook: notebook} do
      update_attrs = %{title: nil, description: nil}
      assert {:error, %Ecto.Changeset{}} = Notebooks.update_notebook(notebook, update_attrs)
    end

    test "delete_notebook/1 deletes the notebook", %{notebook: notebook} do
      assert {:ok, %Notebook{}} = Notebooks.delete_notebook(notebook)
      assert_raise Ecto.NoResultsError, fn -> Notebooks.get_notebook!(notebook.id) end
    end
  end
end

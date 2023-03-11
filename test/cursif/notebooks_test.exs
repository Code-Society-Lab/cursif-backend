defmodule Cursif.NotebooksTest do
  use Cursif.DataCase

  alias Cursif.Notebooks

  describe "notebooks" do
    alias Cursif.Notebooks.Notebook

    import Cursif.NotebooksFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_notebooks/0 returns all notebooks" do
      notebook = notebook_fixture()
      assert Notebooks.list_notebooks() == [notebook]
    end

    test "get_notebook!/1 returns the notebook with given id" do
      notebook = notebook_fixture()
      assert Notebooks.get_notebook!(notebook.id) == notebook
    end

    test "create_notebook/1 with valid data creates a notebook" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %Notebook{} = notebook} = Notebooks.create_notebook(valid_attrs)
      assert notebook.description == "some description"
      assert notebook.title == "some title"
    end

    test "create_notebook/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notebooks.create_notebook(@invalid_attrs)
    end

    test "update_notebook/2 with valid data updates the notebook" do
      notebook = notebook_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Notebook{} = notebook} = Notebooks.update_notebook(notebook, update_attrs)
      assert notebook.description == "some updated description"
      assert notebook.title == "some updated title"
    end

    test "update_notebook/2 with invalid data returns error changeset" do
      notebook = notebook_fixture()
      assert {:error, %Ecto.Changeset{}} = Notebooks.update_notebook(notebook, @invalid_attrs)
      assert notebook == Notebooks.get_notebook!(notebook.id)
    end

    test "delete_notebook/1 deletes the notebook" do
      notebook = notebook_fixture()
      assert {:ok, %Notebook{}} = Notebooks.delete_notebook(notebook)
      assert_raise Ecto.NoResultsError, fn -> Notebooks.get_notebook!(notebook.id) end
    end

    test "change_notebook/1 returns a notebook changeset" do
      notebook = notebook_fixture()
      assert %Ecto.Changeset{} = Notebooks.change_notebook(notebook)
    end
  end

  describe "notebooks" do
    alias Cursif.Notebooks.Notebook

    import Cursif.NotebooksFixtures

    @invalid_attrs %{description: nil, title: nil, visibility: nil}

    test "list_notebooks/0 returns all notebooks" do
      notebook = notebook_fixture()
      assert Notebooks.list_notebooks() == [notebook]
    end

    test "get_notebook!/1 returns the notebook with given id" do
      notebook = notebook_fixture()
      assert Notebooks.get_notebook!(notebook.id) == notebook
    end

    test "create_notebook/1 with valid data creates a notebook" do
      valid_attrs = %{description: "some description", title: "some title", visibility: "some visibility"}

      assert {:ok, %Notebook{} = notebook} = Notebooks.create_notebook(valid_attrs)
      assert notebook.description == "some description"
      assert notebook.title == "some title"
      assert notebook.visibility == "some visibility"
    end

    test "create_notebook/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notebooks.create_notebook(@invalid_attrs)
    end

    test "update_notebook/2 with valid data updates the notebook" do
      notebook = notebook_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", visibility: "some updated visibility"}

      assert {:ok, %Notebook{} = notebook} = Notebooks.update_notebook(notebook, update_attrs)
      assert notebook.description == "some updated description"
      assert notebook.title == "some updated title"
      assert notebook.visibility == "some updated visibility"
    end

    test "update_notebook/2 with invalid data returns error changeset" do
      notebook = notebook_fixture()
      assert {:error, %Ecto.Changeset{}} = Notebooks.update_notebook(notebook, @invalid_attrs)
      assert notebook == Notebooks.get_notebook!(notebook.id)
    end

    test "delete_notebook/1 deletes the notebook" do
      notebook = notebook_fixture()
      assert {:ok, %Notebook{}} = Notebooks.delete_notebook(notebook)
      assert_raise Ecto.NoResultsError, fn -> Notebooks.get_notebook!(notebook.id) end
    end

    test "change_notebook/1 returns a notebook changeset" do
      notebook = notebook_fixture()
      assert %Ecto.Changeset{} = Notebooks.change_notebook(notebook)
    end
  end
end

defmodule Cursif.Notebooks do
  @moduledoc """
  The Notebooks context.
  """

  import Ecto.Query, warn: false
  alias Cursif.Repo

  alias CursifWeb.Emails.UserEmail

  alias Cursif.Notebooks.{Notebook, Collaborator, Favorite, Policy}
  alias Cursif.Accounts.User
  alias Cursif.Accounts

  defdelegate authorize(action, user, params), to: Policy

  @doc """
  Returns the list of notebooks available to a user.

  ## Examples

      iex> list_notebooks(user)
      [%Notebook{}, ...]

      iex> list_notebooks(user, [favorite: true])
      [%Notebook{}, ...]
  """
  @spec list_notebooks(User.t(), map()) :: list(Notebook.t())
  def list_notebooks(user, opts \\ [])

  def list_notebooks(%User{id: user_id}, [favorite: true]) do
    query = from n in Notebook,
              left_join: c in assoc(n, :collaborators),
              left_join: f in assoc(n, :favorites),
              where: (n.owner_id == ^user_id or c.id == ^user_id),
              where: f.id == ^user_id,
              distinct: true

    Repo.preload(
      Repo.all(query),
      [
        :macros,
        :favorites,
        collaborators: [:user],
        pages: [:author]
      ]
    )
  end

  def list_notebooks(%User{id: user_id}, _opts) do
    query = from n in Notebook,
              left_join: c in assoc(n, :collaborators),
              where: n.owner_id == ^user_id or c.id == ^user_id,
              distinct: true

    Repo.preload(
      Repo.all(query),
      [
        :macros,
        :favorites,
        collaborators: [:user],
        pages: [:author]
      ]
    )
  end

  @doc """
  Gets a single notebook by its `id`.

  Raises `Ecto.NoResultsError` if the Notebook does not exist.

  Associations can be preloaded by passing a list of associations to the
  `:preloads` option.

  ## Examples

      iex> get_notebook!(123)
      %Notebook{}

      iex> get_notebook!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_notebook!(binary()) :: Notebook.t()
  def get_notebook!(id) do
    Notebook
    |> Repo.get!(id) 
    |> Repo.preload([:macros, :favorites, collaborators: [:user], pages: [:author]])
  end

  @doc """
  Creates a notebook.

  ## Examples

      iex> create_notebook(%{field: value})
      {:ok, %Notebook{}}

      iex> create_notebook(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_notebook(map()) :: {:ok, Notebook.t()} | {:error, %Ecto.Changeset{}}
  def create_notebook(attrs \\ %{}) do
    %Notebook{}
    |> Notebook.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a notebook.

  ## Examples

      iex> update_notebook(notebook, %{field: new_value})
      {:ok, %Notebook{}}

      iex> update_notebook(notebook, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_notebook(Notebook.t(), map()) :: {:ok, Notebook.t()} | {:error, %Ecto.Changeset{}}
  def update_notebook(%Notebook{} = notebook, attrs) do
    notebook
    |> Notebook.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a notebook.

  ## Examples

      iex> delete_notebook(notebook)
      {:ok, %Notebook{}}

      iex> delete_notebook(notebook)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_notebook(Notebook.t()) :: {:ok, Notebook.t()} | {:error, %Ecto.Changeset{}}
  def delete_notebook(%Notebook{} = notebook) do
    Repo.delete(notebook)
  end

  @doc """
  Fetch the owner of the notebook

  ## Example

    iex> get_owner!(notebook)
    %User{}

    iex> get_owner!(notebook)
    {:error, "No owner found"}

  """
  @spec get_owner!(Notebook.t()) :: User.t() | {:error, String.t()}
  def get_owner!(%{owner_id: owner_id}),
    do: Accounts.get_user!(owner_id)

  @doc """
  Checks if the user is the owner of the notebook

  ## Examples

    iex> owner?(notebook, user)
    true

    iex> owner?(notebook, user)
    false

  """
  @spec owner?(Notebook.t(), User.t()) :: boolean()
  def owner?(%{owner_id: owner_id}, %{id: user_id}),
    do: owner_id == user_id

  @doc """
  Adds a collaborator to the notebook.

  ## Examples

      iex> add_collaborator(%{field: value})
      {:ok, %Collaborator{}}

      iex> add_collaborator(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec add_collaborator(map()) :: {:ok, Collaborator.t()} | {:error, %Ecto.Changeset{}}
  def add_collaborator(attrs) do
    %Collaborator{}
    |> Collaborator.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a given collaborator.

  ## Examples

      iex> delete_collaborator(collaborator)
      {:ok, %Collaborator{}}

      iex> delete_collaborator(collaborator)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_collaborator(Collaborator.t()) :: {:ok, Collaborator.t()} | {:error, %Ecto.Changeset{}}
  def delete_collaborator(collaborator),
    do: Repo.delete(collaborator)

  @doc """
  Checks if the user is a collaborator of the notebook

  ## Examples

    iex> collaborator?(notebook, user)
    true

    iex> collaborator?(notebook, user)
    false

  """
  @spec collaborator?(Notebook.t(), User.t()) :: boolean()
  def collaborator?(%{id: notebook_id}, %{id: user_id}) do
    Repo.exists?(from c in Collaborator,
      where: c.notebook_id == ^notebook_id and c.user_id == ^user_id)
  end

  @doc """
  Deletes a collaborator by user id.

  ## Examples

      iex> delete_collaborator_by_user_id(notebook_id, user_id)
      {:ok, 1}

      iex> delete_collaborator_by_user_id(notebook_id, user_id)
      {:error, "No collaborator found"}
  """
  @spec delete_collaborator_by_user_id(binary(), binary()) :: {:ok, integer()} | {:error, String.t()}
  def delete_collaborator_by_user_id(notebook_id, user_id) do
    Repo.delete_all(from n in Collaborator,
      where: n.user_id == ^user_id and n.notebook_id == ^notebook_id)
  end

  @doc "Send invite notification to a user."
  @spec send_notification(User.t(), binary(), User.t()) :: {:ok, String.t()} | {:error, String}
  def send_notification(%User{} = user, notebook_id, owner) do
    UserEmail.send_collaborator_email(user, notebook_id, owner)
  end

  @doc "Adds a notebook to a user's favorites."
  @spec add_favorite(map()) :: {:ok, Favorite.t()} | {:error, %Ecto.Changeset{}}
  def add_favorite(attrs) do
    %Favorite{}
    |> Favorite.changeset(attrs)
    |> Repo.insert()
  end

  @doc "Removes a notebook from a user's favorites."
  @spec delete_favorite_by_user_id(binary(), binary()) :: {:ok, integer()} | {:error, String.t()}
  def delete_favorite_by_user_id(notebook_id, user_id) do
    Repo.delete_all(from n in Favorite,
      where: n.user_id == ^user_id and n.notebook_id == ^notebook_id)
  end

  def favorite?(notebook, user) do
    Repo.exists?(from f in Favorite,
      where: f.notebook_id == ^notebook.id and f.user_id == ^user.id)
  end
end

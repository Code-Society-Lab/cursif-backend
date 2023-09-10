defmodule Cursif.Notebooks.Policy do
  @behaviour Bodyguard.Policy

  alias Cursif.Notebooks.Notebook

  def authorize(:owner, user, notebook),
    do: Notebook.owner?(notebook, user)

  def authorize(:collaborator, user, notebook),
    do: Notebook.owner?(notebook, user) || Notebook.collaborator?(notebook, user)

  def authorize(_, _, _),
    do: false
end
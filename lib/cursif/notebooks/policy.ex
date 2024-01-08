defmodule Cursif.Notebooks.Policy do
  @behaviour Bodyguard.Policy

  alias Cursif.Notebooks

  def authorize(:owner, user, notebook),
    do: Notebooks.owner?(notebook, user)

  def authorize(:collaborator, user, notebook),
    do: Notebooks.owner?(notebook, user) || Notebooks.collaborator?(notebook, user)

  def authorize(_, _, _),
    do: false
end
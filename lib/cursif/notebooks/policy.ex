defmodule Cursif.Notebooks.Policy do
  @behaviour Bodyguard.Policy

  alias Cursif.Notebooks.{Notebook, Page}
  alias Cursif.{Notebooks, Pages}

  def authorize(:owner, user, %Notebook{} = notebook),
    do: Notebooks.owner?(notebook, user)

  def authorize(:collaborator, user, %Notebook{} = notebook),
    do: Notebooks.owner?(notebook, user) || Notebooks.collaborator?(notebook, user)

  def authorize(:owner, user, %Page{} = page),
    do: Pages.owner?(page, user)

  def authorize(:collaborator, user, %Page{} = page),
    do: Pages.owner?(page, user) || Pages.collaborator?(page, user)

  def authorize(_, _, _),
    do: false
end
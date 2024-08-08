defmodule CursifWeb.GraphqlWSSocket do
  import Cursif.Guardian

  use Absinthe.GraphqlWS.Socket,
    schema: CursifWeb.Schema

  @impl true
  def handle_init(params, socket) do
    current_user = get_current_user(params)
    socket = assign_context(socket, current_user: current_user)

    {:ok, %{}, socket}
  end

  @impl true
  def handle_info({:subscription, _id, %{"data" => %{"pageUpdated" => thing_changes}}}, %{assigns: %{thing: thing}} = socket) do
    IO.inspect(thing_changes)
    {:ok, socket}
  end

  defp get_current_user(%{"authToken" => token}) do
    with {:ok, user} <- CursifWeb.Context.authorize(token) do
      user
    end
  end

  defp get_current_user(_other) do
    {:error, "unauthorized"}
  end

  def authorize(token) do
    case decode_and_verify(token) do
      {:ok, claims} -> resource_from_claims(claims)
      {:error, reason} -> {:error, reason}
    end
  end
end
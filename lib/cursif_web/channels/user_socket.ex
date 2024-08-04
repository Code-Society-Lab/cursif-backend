defmodule CursifWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket,
    schema: CursifWeb.Schema

  def connect(params, socket, connect_info) do
    current_user = current_user(params)

    socket = Absinthe.Phoenix.Socket.put_options(socket, context: %{
      current_user: current_user
    })

    {:ok, socket}
  end

  # move to context
  defp current_user(%{"Authorization" => "Bearer " <> token}) do
    with {:ok, user, _claims} <- CursifWeb.Context.authorize(token) do
      {:ok, user}
    end
  end

  defp current_user(_other) do
    {:error, "unauthorized"}
  end

  def id(_socket), do: nil
end
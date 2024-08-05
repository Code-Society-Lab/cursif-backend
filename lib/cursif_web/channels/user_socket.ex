defmodule CursifWeb.UserSocket do
  import Cursif.Guardian

  use Phoenix.Socket
  use Absinthe.Phoenix.Socket,
    schema: CursifWeb.Schema


  def connect(params, socket) do
    IO.inspect(params)
    current_user = get_current_user(params)

    socket = Absinthe.Phoenix.Socket.put_options(socket, context: %{
      current_user: current_user
    })

    {:ok, socket}
  end

  # move to context
  defp get_current_user(%{"Authorization" => "Bearer " <> token}) do
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

  def id(_socket), do: nil
end
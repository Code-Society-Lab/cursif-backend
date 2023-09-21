defmodule CursifWeb.RateLimit do
  @moduledoc """
  This module is a plug that will rate limit requests based on the client's IP address.
  """
  @behaviour Plug
  import Plug.Conn
  alias Hammer

  @impl true
  def init(options), do: options

  @impl true
  def call(conn, _opts) do
    rate_limit(conn)
  end

  defp rate_limit(conn) do
    client_ip = get_client_ip(conn)
    case Hammer.check_rate(client_ip, 60_000, 60) do
      {:allow, _count} -> conn
      {:deny, _limit} -> 
        conn 
        |> put_resp_header("retry-after", "60") 
        |> send_resp(
          429,
          Jason.encode!(%{
            details: "Too many requests.",
            status: 429
          })
        )
        |> halt()
    end
  end

  # Get the client's IP address
  defp get_client_ip(%{remote_ip: remote_ip}) do
    remote_ip
    |> :inet.ntoa()
    |> to_string()
  end
end

defmodule CursifWeb.Middlewares.RateLimit do
  @moduledoc """
  This module is a plug that will rate limit requests based on the client's IP address.
  """
  @behaviour Plug
  alias Hammer

  def init(options), do: options

  def call(conn, _opts) do
    rate_limit(conn)
  end

  defp rate_limit(conn) do
    if client_exceeds_limit?(conn) do
      conn
      |> Plug.Conn.put_status(:too_many_requests)
      |> Plug.Conn.put_resp_header("retry-after", "60")
      |> Plug.Conn.send_resp(:too_many_requests, "Rate limit exceeded")
    else
      conn
    end
  end

  # Check if the client has exceeded the rate limit
  defp client_exceeds_limit?(conn) do
    client_ip = get_client_ip(conn)
    # Check if the user has exceeded the rate limit based on their IP address
    case Hammer.check_rate(client_ip, 60_000, 60) do
      {:allow, _count} -> false
      {:deny, _limit} -> true
    end
  end

  # Get the client's IP address
  defp get_client_ip(conn) do
    {ip1, ip2, ip3, ip4} = conn.remote_ip
    "#{ip1}.#{ip2}.#{ip3}.#{ip4}"
  end
end

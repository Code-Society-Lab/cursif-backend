defmodule CursifWeb.Context do
  @behaviour Plug

  import Plug.Conn
  import Cursif.Guardian

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Builds the context for the Absinthe schema.
  """
  def build_context(conn) do
    %{
      client: get_client(conn), 
      current_user: get_current_user(conn)
    }
  end
  
  def get_client(conn),
    do: %{ip: conn.remote_ip}
  
  def get_current_user(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
      {:ok, current_user} <- authorize(token) do
        current_user
      end
  end

  def authorize(token) do
    case decode_and_verify(token) do
      {:ok, claims} -> resource_from_claims(claims)
      {:error, reason} -> {:error, reason}
    end
  end
end
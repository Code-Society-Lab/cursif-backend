defmodule CursifWeb.Context do
  @behaviour Plug

  import Plug.Conn
  # import Cursif.Guardian
  import Cursif.Token

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
    case verify(token, :session) do
      {:ok, user} -> {:ok, user}
      {:error, _} -> {:error, :unauthenticated}
    end
  end
end
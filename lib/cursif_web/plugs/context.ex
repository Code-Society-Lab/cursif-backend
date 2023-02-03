defmodule CursifWeb.Context do
  @behaviour Plug

  import Plug.Conn
  import Ecto.Query, only: [from: 2]

  alias Cursif.Repo

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    query = from s in "user_tokens",
                 where: s.token == ^token and (is_nil(s.expires_at) or s.expires_at > ^DateTime.utc_now),
                 select: s.user_id
    query
    |> Repo.one
    |> case do
         nil -> {:error, "invalid authorization token"}
         user -> {:ok, user}
       end
  end
end
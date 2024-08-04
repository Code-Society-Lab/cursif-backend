defmodule CursifWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :cursif
  use Absinthe.Phoenix.Endpoint

  socket "/socket", CursifWeb.UserSocket,
    websocket: [
      connect_info: [:peer_data, :trace_context_headers, :x_headers, :uri]
    ],
    longpoll: false

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_cursif_key",
    signing_salt: "7u2dtDFr"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :cursif,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :cursif
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug CursifWeb.RateLimit
  plug CORSPlug

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug CursifWeb.Router
end

defmodule Cursif.Users.Pipeline do
  use Guardian.Plug.Pipeline,
      otp_app: :cursif,
      error_handler: Cursif.Users.ErrorHandler,
      module: Cursif.Users.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
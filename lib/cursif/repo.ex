defmodule Cursif.Repo do
  use Ecto.Repo,
    otp_app: :cursif,
    adapter: Ecto.Adapters.Postgres
end

defmodule Cursif.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    unless Mix.env == :prod do
      Mix.Task.run("loadconfig")
    end

    children = [
      # Start the Ecto repository
      Cursif.Repo,
      # Start the Telemetry supervisor
      CursifWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Cursif.PubSub},
      # Start the Endpoint (http/https)
      CursifWeb.Endpoint,
      # Start a worker by calling: Cursif.Worker.start_link(arg)
      # {Cursif.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cursif.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CursifWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

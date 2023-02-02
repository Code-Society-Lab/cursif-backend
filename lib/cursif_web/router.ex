defmodule CursifWeb.Router do
  use CursifWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    # Will be used later
  end

  pipeline :require_authenticated_user do
    plug Cursif.Users.Pipeline
  end

  # Public API
  scope "/api", CursifWeb do
    pipe_through :api

    post "/login", SessionController, :login
    post "/register", SessionController, :register
  end

  # Private API
  scope "/api", CursifWeb do
    pipe_through [:api, :require_authenticated_user]

    resources "/users", UserController, except: [:new, :edit, :create]
  end

  # GraphQL API (authenticate required)
  scope "/api" do
    pipe_through [:graphql, :require_authenticated_user]

    forward "/", Absinthe.Plug, schema: CursifWeb.Schema
  end

  # Querying interface available in development (no authentication required)
  if Mix.env() == :dev do
    forward "/graphql", Absinthe.Plug.GraphiQL, schema: CursifWeb.Schema
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CursifWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

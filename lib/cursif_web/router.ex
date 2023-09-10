defmodule CursifWeb.Router do
  use CursifWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug CursifWeb.Context
  end

  # API routes
  scope "/api", CursifWeb do
    pipe_through :api
  end

  # GraphQL API (authenticate required)
  scope "/api" do
    pipe_through :graphql

    forward "/", Absinthe.Plug, schema: CursifWeb.Schema
  end


  # Enables GraphiQL for development only.
  #
  # You can access it by browsing to http://localhost:4000/graphiql. Authentication is still
  # required to perform requests.
  if Mix.env() == :dev do
    scope "/graphiql" do
      pipe_through :graphql

      forward "/", Absinthe.Plug.GraphiQL, schema: CursifWeb.Schema
    end
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

      get "/users/confirm", CursifWeb.Controllers.UserConfirmation, :confirm
      post "/users/confirm", CursifWeb.Controllers.UserConfirmation, :confirm
      get "/users/confirm/:token", CursifWeb.Controllers.UserConfirmation, :confirm
      post "/users/confirm/:token", CursifWeb.Controllers.UserConfirmation, :confirm
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

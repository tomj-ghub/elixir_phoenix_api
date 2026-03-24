defmodule ElixirPhoenixApiWeb.Router do
  use ElixirPhoenixApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirPhoenixApiWeb do

    pipe_through :api
    get "/movies", MoviesController, :getAll
    get "/movie/:id", MoviesController, :getOne
    get "/movie/search/:title", MoviesController, :searchMovie
    post "/movie", MoviesController, :upsertMovie
    delete "/movie/:id", MoviesController, :deleteOne
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:elixir_phoenix_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ElixirPhoenixApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

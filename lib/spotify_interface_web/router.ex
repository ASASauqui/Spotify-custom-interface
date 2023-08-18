defmodule SpotifyInterfaceWeb.Router do
  use SpotifyInterfaceWeb, :router

  import SpotifyInterfaceWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SpotifyInterfaceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SpotifyInterfaceWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/artist/:id", ArtistLive
    live "/album/:id", AlbumLive

    get "/logout", AuthenticationController, :logout
  end

  scope "/", SpotifyInterfaceWeb do
    pipe_through :browser

    get "/callback", AuthenticationController, :callback

    live "/login", LoginLive
    post "/login", AuthenticationController, :login
  end

  scope "/", SpotifyInterfaceWeb do
    pipe_through [:browser]

    live_session :access_token,
      on_mount: [{SpotifyInterfaceWeb.UserAuth, :ensure_authenticated}] do
      live "/", HomeLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SpotifyInterfaceWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:spotify_interface, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SpotifyInterfaceWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

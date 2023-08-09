defmodule SpotifyInterface.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SpotifyInterfaceWeb.Telemetry,
      # Start the Ecto repository
      SpotifyInterface.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SpotifyInterface.PubSub},
      # Start Finch
      {Finch, name: SpotifyInterface.Finch},
      # Start the Endpoint (http/https)
      SpotifyInterfaceWeb.Endpoint
      # Start a worker by calling: SpotifyInterface.Worker.start_link(arg)
      # {SpotifyInterface.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SpotifyInterface.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SpotifyInterfaceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

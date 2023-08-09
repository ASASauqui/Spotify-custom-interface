defmodule SpotifyInterface.Repo do
  use Ecto.Repo,
    otp_app: :spotify_interface,
    adapter: Ecto.Adapters.Postgres
end

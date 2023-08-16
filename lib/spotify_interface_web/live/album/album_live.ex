defmodule SpotifyInterfaceWeb.AlbumLive do
  use SpotifyInterfaceWeb, :live_view
  import SpotifyInterface.Services.SpotifyService

  def mount(params, _session, socket) do
    id = params["id"]

    album = get_album(id)

    tracks = get_album_tracks(id)

    {:ok, assign(socket, album: album, tracks: tracks)}
  end
end

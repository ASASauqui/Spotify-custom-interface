defmodule SpotifyInterfaceWeb.AlbumLive do
  use SpotifyInterfaceWeb, :live_view
  import SpotifyInterfaceWeb.Services.SpotifyService

  def mount(params, _session, socket) do
    id = params["id"]

    album = get_album(id)

    tracks = get_album_tracks(id)

    socket = assign(socket, album: album, tracks: tracks)

    {:ok, socket}
  end
end

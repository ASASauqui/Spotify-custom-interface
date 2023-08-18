defmodule SpotifyInterfaceWeb.AlbumLive do
  use SpotifyInterfaceWeb, :live_view
  import SpotifyInterface.Services.SpotifyService

  def mount(params, session, socket) do
    access_token = session["access_token"]

    id = params["id"]

    album = get_album(id, access_token)

    tracks = get_album_tracks(id, access_token)

    socket = assign(socket,
                    album: album,
                    tracks: tracks
      )

    {:ok, socket}
  end
end

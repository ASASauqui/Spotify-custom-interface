defmodule SpotifyInterfaceWeb.AlbumLive do
  use SpotifyInterfaceWeb, :live_view
  alias SpotifyInterface.Services.SpotifyService

  def mount(params, session, socket) do
    access_token = session["access_token"]

    id = params["id"]

    socket =
      assign(socket,
             access_token: access_token,
             album: %{},
             tracks: []
      )
      |> get_album(id, access_token)
      |> get_album_tracks(id, access_token)

    {:ok, socket}
  end

  defp get_album(socket, id, access_token) do
    response = SpotifyService.get_album(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket
        |> put_flash(:error, "Error #{status}: #{message}.")
      _ ->
        socket
        |> assign(album: response)
    end
  end

  defp get_album_tracks(socket, id, access_token) do
    response = SpotifyService.get_album_tracks(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket
        |> put_flash(:error, "Error #{status}: #{message}.")
      _ ->
        socket
        |> assign(tracks: response)
    end
  end
end

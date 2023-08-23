defmodule SpotifyInterfaceWeb.ArtistLive do
  use SpotifyInterfaceWeb, :live_view
  alias SpotifyInterface.Services.SpotifyService

  def mount(params, session, socket) do
    access_token = session["access_token"]

    id = params["id"]

    socket =
      assign(socket,
             access_token: access_token,
             artist: %{},
             albums: [],
             top_tracks: [],
             related_artists: [],
             followers: ""
      )
      |> get_artist(id, access_token)
      |> get_albums_by_artist(id, access_token)
      |> get_top_tracks_by_artist(id, access_token)
      |> get_related_artists(id, access_token)

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    socket = assign(socket, followers: socket.assigns.artist.total_followers)

    {:noreply, socket}
  end

  defp get_artist(socket, id, access_token) do
    response = SpotifyService.get_artist(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket
        |> put_flash(:error, "Error #{status}: #{message}.")
        |> redirect(to: "/logout")

      _ ->
        socket
        |> assign(artist: response)
    end
  end

  defp get_albums_by_artist(socket, id, access_token) do
    response = SpotifyService.get_albums_by_artist(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket
        |> put_flash(:error, "Error #{status}: #{message}.")
        |> redirect(to: "/logout")
      _ ->
        socket
        |> assign(albums: response)
    end
  end

  defp get_top_tracks_by_artist(socket, id, access_token) do
    response = SpotifyService.get_top_tracks_by_artist(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket
        |> put_flash(:error, "Error #{status}: #{message}.")
        |> redirect(to: "/logout")
      _ ->
        socket
        |> assign(top_tracks: response)
    end
  end

  defp get_related_artists(socket, id, access_token) do
    response = SpotifyService.get_related_artists(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket
        |> put_flash(:error, "Error #{status}: #{message}.")
        |> redirect(to: "/logout")
      _ ->
        socket
        |> assign(related_artists: response)
    end
  end
end

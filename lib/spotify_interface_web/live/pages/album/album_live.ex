defmodule SpotifyInterfaceWeb.AlbumLive do
  use SpotifyInterfaceWeb, :live_view
  alias SpotifyInterface.Services.SpotifyArtistsService
  alias SpotifyInterface.Services.SpotifyAlbumsService
  alias SpotifyInterfaceWeb.PlayerBarComponent
  alias SpotifyInterface.Formatters.NumberFormatters

  def mount(params, session, socket) do
    access_token = session["access_token"]

    id = params["id"]

    socket =
      assign(socket,
             access_token: access_token,
             album: %{},
             artist: %{},
             tracks: [],
             total_album_duration: "",
             release_year: "",
             context_uri: "",
             track_uri: ""
      )

    with {:ok, socket} <- get_album(socket, id, access_token) do
      with {:ok, socket} <- get_artist(socket, Enum.at(socket.assigns.album["artists"], 0)["id"], access_token) do
        {:ok, socket}
      else
        {_, socket} -> {:ok, redirect(socket, to: "/logout")}
      end
    else
      {_, socket} -> {:ok, redirect(socket, to: "/logout")}
    end
  end

  def handle_params(_params, _uri, socket) do
    socket = assign(socket, :tracks, socket.assigns.album["tracks"]["items"])

    socket = assign(socket, :total_album_duration, get_total_album_duration(socket))

    socket = assign(socket, :release_year, NumberFormatters.get_year_from_date(socket.assigns.album["release_date"]))

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    send_update(PlayerBarComponent, id: "player_bar_component", access_token: socket.assigns.access_token, track_uri: socket.assigns.track_uri)

    {:noreply, socket}
  end

  def handle_info({:api_error, %{status: status, message: message}}, socket) do
    socket =
      socket
      |> put_flash(:error, "Error #{status}: #{message}.")
    {:noreply, socket}
  end

  def handle_event("play_track", params, socket) do
    socket =
      assign(socket,
             context_uri: params["context_uri"],
             track_uri: params["uri"]
      )

    PlayerBarComponent.handle_event("start-resume-playback", params, socket)

    {:noreply, socket}
  end

  defp get_album(socket, id, access_token) do
    response = SpotifyAlbumsService.get_album(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket =
          socket
          |> put_flash(:error, "Error #{status}: #{message}.")
        {:error, socket}
      {:ok, decoded_response} ->
        socket =
          socket
          |> assign(album: decoded_response)
        {:ok, socket}
    end
  end

  defp get_artist(socket, id, access_token) do
    response = SpotifyArtistsService.get_artist(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket =
          socket
          |> put_flash(:error, "Error #{status}: #{message}.")
        {:error, socket}
      {:ok, decoded_response} ->
        socket =
          socket
          |> assign(artist: decoded_response)
        {:ok, socket}
    end
  end

  defp get_total_album_duration(socket) do
    tracks = socket.assigns.album["tracks"]["items"]
    total_duration = Enum.reduce(tracks, 0, fn track, acc ->
      acc + track["duration_ms"]
    end)
    NumberFormatters.ms_to_hour_min_sec(total_duration)
  end
end

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
             tracks: [],
             total_album_duration: "",
             release_year: ""
      )
      |> get_album(id, access_token)

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    socket = assign(socket, :tracks, socket.assigns.album.tracks["items"])

    socket = assign(socket, :total_album_duration, get_total_album_duration(socket))

    socket = assign(socket, :release_year, get_year(socket.assigns.album.release_date))

    {:noreply, socket}
  end

  defp get_album(socket, id, access_token) do
    response = SpotifyService.get_album(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket
        |> put_flash(:error, "Error #{status}: #{message}.")
        |> redirect(to: "/logout")
      _ ->
        socket
        |> assign(album: response)
    end
  end

  defp get_total_album_duration(socket) do
    tracks = socket.assigns.album.tracks["items"]
    total_duration = Enum.reduce(tracks, 0, fn track, acc ->
      acc + track["duration_ms"]
    end)
    ms_to_hour_min_sec(total_duration)
  end

  defp ms_to_hour_min_sec(ms) do
    min = div(ms, 60000)

    if min < 60 do
      "#{min} min"
    else
      hour = div(min, 60)
      min = rem(min, 60)
      "#{hour} h #{min} min"
    end
  end

  defp ms_to_min_sec(ms) do
    min = div(ms, 60000)
    sec = rem(div(ms, 1000), 60)

    if sec < 10 do
      "#{min}:0#{sec}"
    else
      "#{min}:#{sec}"
    end
  end

  defp get_year(date) do
    [year, _, _] = String.split(date, "-")
    year
  end
end

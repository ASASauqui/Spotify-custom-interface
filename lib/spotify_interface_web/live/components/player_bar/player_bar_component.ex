defmodule SpotifyInterfaceWeb.PlayerBarComponent do
  use SpotifyInterfaceWeb, :live_component
  alias SpotifyInterface.Services.SpotifyPlayerService
  alias SpotifyInterface.Formatters.NumberFormatters

  def mount(socket) do
    socket =
      assign(socket,
             device: nil,
             track_name: nil,
             artist_names: nil,
             image_href: nil,
             is_playing: false,
             progress_ms: nil,
             track_duration_ms: nil,
             volume_percent: nil,
             context_uri: nil,
             track_uri: nil
      )

    :timer.send_interval(1000, :tick)

    {:ok, socket}
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)

    with {:ok, socket} <- get_playback_state(socket, assigns.access_token) do
      {:ok, socket}
    else
      {:error, socket} -> {:ok, socket}
    end
  end

  def get_playback_state(socket, access_token) do
    response = SpotifyPlayerService.get_playback_state(access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket =
          assign(socket,
                 device: nil,
                 track_name: nil,
                 artist_names: nil,
                 image_href: nil,
                 is_playing: false,
                 progress_ms: nil,
                 track_duration_ms: nil,
                 volume_percent: nil,
                 context_uri: nil,
                 track_uri: nil
          )
        send(self(), {:api_error, %{status: status, message: message}})
        {:error, socket}
      {:ok, decoded_response} ->
        socket =
          assign(socket,
                 device: decoded_response,
                 track_name: decoded_response["item"]["name"],
                 artist_names: if decoded_response["item"]["artists"] do Enum.map(decoded_response["item"]["artists"], fn artist -> artist["name"] end) |> Enum.join(", ") else nil end,
                 image_href: if decoded_response["item"]["album"]["images"] do Enum.at(decoded_response["item"]["album"]["images"], 0)["url"] else nil end,
                 is_playing: decoded_response["is_playing"],
                 progress_ms: decoded_response["progress_ms"],
                 track_duration_ms: decoded_response["item"]["duration_ms"],
                 volume_percent: decoded_response["device"]["volume_percent"],
                 context_uri: decoded_response["context"]["uri"],
                 track_uri: decoded_response["item"]["uri"]
          )

        {:ok, socket}
    end
  end

  def handle_event("start-resume-playback", params, socket) do
    :timer.sleep(1000)
    socket = assign(socket, is_playing: true)

    response = SpotifyPlayerService.start_resume_playback(socket.assigns.access_token, params["context_uri"], params["uri"], 0)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        send(self(), {:api_error, %{status: status, message: message}})
        {:noreply, socket}
      {:ok, _} ->
        {:noreply, socket}
    end
  end

  def handle_event("pause-playback", _, socket) do
    :timer.sleep(1000)
    socket = assign(socket, is_playing: false)

    response = SpotifyPlayerService.pause_playback(socket.assigns.access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        send(self(), {:api_error, %{status: status, message: message}})
        {:noreply, socket}
      {:ok, _} ->
        {:noreply, socket}
    end
  end

  def handle_event("skip-to-next", _, socket) do
    :timer.sleep(1000)
    response = SpotifyPlayerService.skip_to_next(socket.assigns.access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        send(self(), {:api_error, %{status: status, message: message}})
        {:noreply, socket}
      {:ok, _} ->
        {:noreply, socket}
    end
  end

  def handle_event("skip-to-previous", _, socket) do
    :timer.sleep(1000)
    response = SpotifyPlayerService.skip_to_previous(socket.assigns.access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        send(self(), {:api_error, %{status: status, message: message}})
        {:noreply, socket}
      {:ok, _} ->
        {:noreply, socket}
    end
  end

  def handle_event("seek-to-position", %{"progress_ms" => progress_ms}, socket) do
    :timer.sleep(1000)
    response = SpotifyPlayerService.seek_to_position(socket.assigns.access_token, progress_ms)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        send(self(), {:api_error, %{status: status, message: message}})
        {:noreply, socket}
      {:ok, _} ->
        {:noreply, socket}
    end
  end

  def handle_event("set-playback-volume", %{"volume_percent" => volume_percent}, socket) do
    :timer.sleep(1000)
    response = SpotifyPlayerService.set_playback_volume(socket.assigns.access_token, volume_percent)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        send(self(), {:api_error, %{status: status, message: message}})
        {:noreply, socket}
      {:ok, _} ->
        {:noreply, socket}
    end
  end
end

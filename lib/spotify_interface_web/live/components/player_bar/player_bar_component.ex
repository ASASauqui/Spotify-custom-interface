defmodule SpotifyInterfaceWeb.PlayerBarComponent do
  use SpotifyInterfaceWeb, :live_component
  alias SpotifyInterface.Services.SpotifyPlayerService

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    # with {:ok, socket} <- set_playback_volume(socket, assigns.access_token, 10) do
    #   {:ok, socket}
    # else
    #   {_, socket} -> {:ok, socket}
    # end
    {:ok, socket}
  end

  defp get_playback_state(socket, access_token) do
    response = SpotifyPlayerService.get_playback_state(access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        {:error, socket}
      {:ok, decoded_response} ->
        socket =
          socket
          |> assign(device: decoded_response)
        {:ok, socket}
    end
  end

  defp start_resume_playback(socket, access_token, context_uri, position, position_ms) do
    response = SpotifyPlayerService.start_resume_playback(access_token, context_uri, position, position_ms)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        {:error, socket}
      {:ok, decoded_response} ->
        {:ok, socket}
    end
  end

  defp pause_playback(socket, access_token) do
    response = SpotifyPlayerService.pause_playback(access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        {:error, socket}
      {:ok, decoded_response} ->
        {:ok, socket}
    end
  end

  defp skip_to_next(socket, access_token) do
    response = SpotifyPlayerService.skip_to_next(access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        {:error, socket}
      {:ok, decoded_response} ->
        {:ok, socket}
    end
  end

  defp skip_to_previous(socket, access_token) do
    response = SpotifyPlayerService.skip_to_previous(access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        {:error, socket}
      {:ok, decoded_response} ->
        {:ok, socket}
    end
  end

  defp seek_to_position(socket, access_token, position_ms) do
    response = SpotifyPlayerService.seek_to_position(access_token, position_ms)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        {:error, socket}
      {:ok, decoded_response} ->
        {:ok, socket}
    end
  end

  defp set_playback_volume(socket, access_token, volume_percent) do
    response = SpotifyPlayerService.set_playback_volume(access_token, volume_percent)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        {:error, socket}
      {:ok, decoded_response} ->
        {:ok, socket}
    end
  end
end

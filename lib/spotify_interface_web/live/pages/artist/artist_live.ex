defmodule SpotifyInterfaceWeb.ArtistLive do
  use SpotifyInterfaceWeb, :live_view
  alias SpotifyInterface.Services.SpotifyArtistsService
  alias SpotifyInterfaceWeb.PlayerBarComponent

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

    with {:ok, socket} <- get_artist(socket, id, access_token) do
      with {:ok, socket} <- get_albums_by_artist(socket, id, access_token) do
        with {:ok, socket} <- get_top_tracks_by_artist(socket, id, access_token) do
          with {:ok, socket} <- get_related_artists(socket, id, access_token) do
            {:ok, socket}
          else
            {_, socket} -> {:ok, redirect(socket, to: "/logout")}
          end
        else
          {_, socket} -> {:ok, redirect(socket, to: "/logout")}
        end
      else
        {_, socket} -> {:ok, redirect(socket, to: "/logout")}
      end
    else
      {_, socket} -> {:ok, redirect(socket, to: "/logout")}
    end
  end

  def handle_params(_params, _uri, socket) do
    socket = assign(socket, followers: socket.assigns.artist["followers"]["total"])

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    send_update(PlayerBarComponent, id: "player_bar_component", access_token: socket.assigns.access_token)

    {:noreply, socket}
  end

  def handle_info({:api_error, %{status: status, message: message}}, socket) do
    socket =
      socket
      |> put_flash(:error, "Error #{status}: #{message}.")
    {:noreply, socket}
  end

  def handle_event("play-track", params, socket) do
    PlayerBarComponent.handle_event("start-resume-playback", params, socket)

    {:noreply, socket}
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

  defp get_albums_by_artist(socket, id, access_token) do
    response = SpotifyArtistsService.get_albums_by_artist(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket =
          socket
          |> put_flash(:error, "Error #{status}: #{message}.")
        {:error, socket}
      {:ok, decoded_response} ->
        socket =
          socket
          |> assign(albums: decoded_response)
        {:ok, socket}
    end
  end

  defp get_top_tracks_by_artist(socket, id, access_token) do
    response = SpotifyArtistsService.get_top_tracks_by_artist(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket =
          socket
          |> put_flash(:error, "Error #{status}: #{message}.")
        {:error, socket}
      {:ok, decoded_response} ->
        socket =
          socket
          |> assign(top_tracks: decoded_response)
        {:ok, socket}
    end
  end

  defp get_related_artists(socket, id, access_token) do
    response = SpotifyArtistsService.get_related_artists(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket =
          socket
          |> put_flash(:error, "Error #{status}: #{message}.")
        {:error, socket}
      {:ok, decoded_response} ->
        socket =
          socket
          |> assign(related_artists: decoded_response)
        {:ok, socket}
    end
  end
end

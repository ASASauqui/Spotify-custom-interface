defmodule SpotifyInterfaceWeb.ArtistLive do
  use SpotifyInterfaceWeb, :live_view
  alias SpotifyInterface.Services.SpotifyService
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
    socket = assign(socket, followers: socket.assigns.artist.total_followers)

    {:noreply, socket}
  end

  defp get_artist(socket, id, access_token) do
    response = SpotifyService.get_artist(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket =
          socket
          |> put_flash(:error, "Error #{status}: #{message}.")
        {:error, socket}
      _ ->
        socket =
          socket
          |> assign(artist: response)
        {:ok, socket}
    end
  end

  defp get_albums_by_artist(socket, id, access_token) do
    response = SpotifyService.get_albums_by_artist(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket =
          socket
          |> put_flash(:error, "Error #{status}: #{message}.")
        {:error, socket}
      _ ->
        socket =
          socket
          |> assign(albums: response)
        {:ok, socket}
    end
  end

  defp get_top_tracks_by_artist(socket, id, access_token) do
    response = SpotifyService.get_top_tracks_by_artist(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket =
          socket
          |> put_flash(:error, "Error #{status}: #{message}.")
        {:error, socket}
      _ ->
        socket =
          socket
          |> assign(top_tracks: response)
        {:ok, socket}
    end
  end

  defp get_related_artists(socket, id, access_token) do
    response = SpotifyService.get_related_artists(id, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket =
          socket
          |> put_flash(:error, "Error #{status}: #{message}.")
        {:error, socket}
      _ ->
        socket =
          socket
          |> assign(related_artists: response)
        {:ok, socket}
    end
  end
end

defmodule SpotifyInterfaceWeb.HomeLive do
  use SpotifyInterfaceWeb, :live_view
  import SpotifyInterface.Services.SpotifyService
  alias SpotifyInterfaceWeb.PlayerBarComponent

  def mount(_params, session, socket) do
    socket =
      assign(socket,
             access_token: session["access_token"],
             search_item: "",
             albums: [],
             artists: [],
             tracks: []
      )

    {:ok, socket}
  end

  def handle_event("search-item", %{"search_item" => ""}, socket) do
    {:noreply, assign(socket, search_item: "", albums: [], artists: [], tracks: [])}
  end

  def handle_event("search-item", %{"search_item" => search_item}, socket) do
    response = search_for_item(search_item, socket.assigns.access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        {:noreply, put_flash(socket, :error, "Error #{status}: #{message}.")}
      _ ->
        {:noreply, assign(socket, search_item: search_item, albums: response.albums, artists: response.artists, tracks: response.tracks)}
    end
  end
end

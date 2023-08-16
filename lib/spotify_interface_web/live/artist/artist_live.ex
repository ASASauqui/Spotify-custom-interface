defmodule SpotifyInterfaceWeb.ArtistLive do
  use SpotifyInterfaceWeb, :live_view
  import SpotifyInterface.Services.SpotifyService

  def mount(_params, _session, socket) do
    socket = assign(socket, search_item: "", albums: [], artists: [], tracks: [])
    {:ok, socket}
  end

  def handle_event("search-item", %{"search_item" => ""}, socket) do
    {:noreply, assign(socket, search_item: "", albums: [], artists: [], tracks: [])}
  end

  def handle_event("search-item", %{"search_item" => search_item}, socket) do
    response = search_for_item(search_item)

    {:noreply, assign(socket, search_item: search_item, albums: response.albums, artists: response.artists, tracks: response.tracks)}
  end
end

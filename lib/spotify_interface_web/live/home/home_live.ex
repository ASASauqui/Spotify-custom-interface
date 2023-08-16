defmodule SpotifyInterfaceWeb.HomeLive do
  use SpotifyInterfaceWeb, :live_view
  import SpotifyInterfaceWeb.Services.SpotifyService

  def mount(_params, _session, socket) do
    socket = assign(socket, search_item: "", albums: [], artists: [], tracks: [])
    {:ok, socket}
  end

  def handle_event("search-item", %{"search_item" => search_item} = %{"search_item" => ""}, socket) do
    {:noreply, assign(socket, search_item: "", albums: [], artists: [], tracks: [])}
  end

  def handle_event("search-item", %{"search_item" => search_item}, socket) do
    response = search_for_item(search_item)

    socket = assign(socket, search_item: search_item, albums: response.albums, artists: response.artists, tracks: response.tracks)
    {:noreply, socket}
  end
end

defmodule SpotifyInterfaceWeb.ArtistLive do
  use SpotifyInterfaceWeb, :live_view
  alias SpotifyInterface.Services.SpotifyService

  def mount(_params, _session, socket) do
    socket = assign(socket,
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
end

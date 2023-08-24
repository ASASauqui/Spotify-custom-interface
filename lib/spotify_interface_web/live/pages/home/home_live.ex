defmodule SpotifyInterfaceWeb.HomeLive do
  use SpotifyInterfaceWeb, :live_view
  alias SpotifyInterface.Services.SpotifyService
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
    with {:ok, socket} <- search_for_item(socket, search_item, socket.assigns.access_token) do
      {:noreply, socket}
    else
      {_, socket} -> {:noreply, redirect(socket, to: "/logout")}
    end
  end

  defp search_for_item(socket, search_item, access_token) do
    response = SpotifyService.search_for_item(search_item, access_token)

    case response do
      {:error, %{"status" => status, "message" => message}} ->
        socket =
          socket
          |> put_flash(:error, "Error #{status}: #{message}.")
        {:error, socket}
      {:ok, decoded_response} ->
        socket =
          socket
          |> assign(search_item: search_item, albums: decoded_response.albums, artists: decoded_response.artists, tracks: decoded_response.tracks)
        {:ok, socket}
    end
  end
end

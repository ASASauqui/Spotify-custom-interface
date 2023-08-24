defmodule SpotifyInterfaceWeb.PlayerBarComponent do
  use SpotifyInterfaceWeb, :live_component
  alias SpotifyInterface.Services.SpotifyService

  def mount(params, session, socket) do
    {:ok, socket}
  end
end

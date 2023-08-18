defmodule SpotifyInterfaceWeb.UserAuth do
  use SpotifyInterfaceWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  def on_mount(:mount_current_user, _params, _session, socket) do
    {:cont, socket}
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    if session["access_token"] do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must log in to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/login")

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_user_is_authenticated, _params, session, socket) do
    if session["access_token"] do
      {:halt, Phoenix.LiveView.redirect(socket, to: signed_in_path(socket))}
    else
      {:cont, socket}
    end
  end

  def require_authenticated_user(conn, _opts) do
    if get_session(conn)["access_token"] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end

  defp signed_in_path(_conn), do: ~p"/"
end

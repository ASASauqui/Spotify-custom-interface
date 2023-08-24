defmodule SpotifyInterfaceWeb.AuthenticationController do
  use SpotifyInterfaceWeb, :controller
  use SpotifyInterfaceWeb, :verified_routes

  alias SpotifyInterface.Crypto.StringGenerator
  alias SpotifyInterface.Crypto.CodeChallenge

  @client_id "dac481deca07439c831856e2cb8f1160"

  def login(conn, _params) do
    redirect_uri = "http://localhost:4000/callback"
    scope = "user-read-private user-read-email user-read-playback-state user-modify-playback-state"

    state = StringGenerator.generate_random_string(16)
    code_verifier = StringGenerator.generate_random_string(128)
    code_challenge = CodeChallenge.generate_code_challenge(code_verifier)

    conn = put_session(conn, :code_verifier, code_verifier)

    args = URI.encode_query(
      [
        {"response_type", "code"},
        {"client_id", @client_id},
        {"scope", scope},
        {"redirect_uri", redirect_uri},
        {"state", state},
        {"code_challenge_method", "S256"},
        {"code_challenge", code_challenge}
      ]
    )

    redirect_url = "https://accounts.spotify.com/authorize?" <> args

    conn
    |> redirect(external: redirect_url)
  end

  def callback(conn, params) do
    code = params["code"]
    redirect_uri = "http://localhost:4000/callback"

    data =
      {:form,
        [
          {"grant_type", "authorization_code"},
          {"code", code},
          {"redirect_uri", redirect_uri},
          {"client_id", @client_id},
          {"code_verifier", get_session(conn, :code_verifier)}
        ]
      }

    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]

    response =
      HTTPoison.post!("https://accounts.spotify.com/api/token",
                      data,
                      headers
        )

    case response.status_code do
      200 ->
        {:ok, body} = Jason.decode(response.body)

        access_token = body["access_token"]
        refresh_token = body["refresh_token"]

        conn
        |> delete_session(:code_verifier)
        |> put_session(:access_token, access_token)
        |> put_session(:refresh_token, refresh_token)
        |> put_flash(:info, "Successfully logged in.")
        |> redirect(to: "/")
      status_code ->
        {:ok, body} = Jason.decode(response.body)

        conn
        |> delete_session(:code_verifier)
        |> put_flash(:error, "Error #{status_code}: #{body["error_description"]}.")
        |> redirect(to: "/login")
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:access_token)
    |> delete_session(:refresh_token)
    |> put_flash(:info, "Successfully logged out.")
    |> redirect(to: "/login")
  end
end

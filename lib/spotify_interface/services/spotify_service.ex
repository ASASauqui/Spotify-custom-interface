defmodule SpotifyInterface.Services.SpotifyService do
  @base_url "https://api.spotify.com/"

  def search_for_item(search, access_token) do
    endpoint = "v1/search"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    encoded_search = URI.encode_www_form(search)

    response = HTTPoison.get!("#{@base_url}#{endpoint}?q=#{encoded_search}&type=album%2Cartist%2Ctrack&market=ES", headers, [])

    case response.status_code do
      200 ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        artists = decoded_response["artists"]["items"]

        albums = decoded_response["albums"]["items"]

        tracks = decoded_response["tracks"]["items"]

        {:ok,
          %{
            artists: artists,
            albums: albums,
            tracks: tracks
          }
        }
       _ ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:error, %{"status" => response.status_code, "message" => decoded_response["error"]["message"]}}
    end
  end

  def get_album(id, access_token) do
    endpoint = "v1/albums"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}?market=ES", headers, [])

    case response.status_code do
      200 ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:ok, decoded_response}
      _ ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:error, %{"status" => response.status_code, "message" => decoded_response["error"]["message"]}}
    end
  end

  def get_artist(id, access_token) do
    endpoint = "v1/artists"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}", headers, [])

    case response.status_code do
      200 ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:ok, decoded_response}
      _ ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:error, %{"status" => response.status_code, "message" => decoded_response["error"]["message"]}}
    end
  end

  def get_albums_by_artist(id, access_token) do
    endpoint = "v1/artists"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}/albums?market=ES", headers, [])

    case response.status_code do
      200 ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:ok, decoded_response["items"]}
      _ ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:error, %{"status" => response.status_code, "message" => decoded_response["error"]["message"]}}
    end
  end

  def get_top_tracks_by_artist(id, access_token) do
    endpoint = "v1/artists"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}/top-tracks?market=ES", headers, [])

    case response.status_code do
      200 ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:ok, decoded_response["tracks"]}
      _ ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:error, %{"status" => response.status_code, "message" => decoded_response["error"]["message"]}}
    end
  end

  def get_related_artists(id, access_token) do
    endpoint = "v1/artists"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}/related-artists?market=ES", headers, [])

    case response.status_code do
      200 ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:ok, decoded_response["artists"]}
      _ ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:error, %{"status" => response.status_code, "message" => decoded_response["error"]["message"]}}
    end
  end
end

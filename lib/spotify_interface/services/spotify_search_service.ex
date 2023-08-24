defmodule SpotifyInterface.Services.SpotifySearchService do
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
end

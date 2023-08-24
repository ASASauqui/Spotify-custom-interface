defmodule SpotifyInterface.Services.SpotifyAlbumsService do
  @base_url "https://api.spotify.com/"

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
end

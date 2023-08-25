defmodule SpotifyInterface.Services.SpotifyPlayerService do
  @base_url "https://api.spotify.com/"

  def get_playback_state(access_token) do
    endpoint = "v1/me/player"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}?market=ES", headers, [])

    case response.status_code do
      200 ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:ok, decoded_response}
      204 ->
        {:error, %{"status" => response.status_code, "message" => "Playback is not active."}}
      _ ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:error, %{"status" => response.status_code, "message" => decoded_response["error"]["message"]}}
    end
  end

  def start_resume_playback(access_token, context_uri, track_uri, position_ms) do
    endpoint = "v1/me/player/play"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    data =
      %{
        "context_uri" => context_uri,
        "offset" => %{"uri" => track_uri},
        "position_ms" => position_ms
      }
      |> Jason.encode!()

    response =
      HTTPoison.put!("#{@base_url}#{endpoint}",
                              data,
                              headers
        )

    case response.status_code do
      204 ->
        {:ok, "Playback started/resumed."}
      _ ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:error, %{"status" => response.status_code, "message" => decoded_response["error"]["message"]}}
    end
  end

  def pause_playback(access_token) do
    endpoint = "v1/me/player/pause"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response =
      HTTPoison.put!("#{@base_url}#{endpoint}",
                              [],
                              headers
        )

    case response.status_code do
      204 ->
        {:ok, "Playback paused."}
      _ ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:error, %{"status" => response.status_code, "message" => decoded_response["error"]["message"]}}
    end
  end

  def skip_to_next(access_token) do
    endpoint = "v1/me/player/next"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response =
      HTTPoison.post!("#{@base_url}#{endpoint}",
                              [],
                              headers
        )

    case response.status_code do
      204 ->
        {:ok, "Skipped to next track."}
      _ ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:error, %{"status" => response.status_code, "message" => decoded_response["error"]["message"]}}
    end
  end

  def skip_to_previous(access_token) do
    endpoint = "v1/me/player/previous"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response =
      HTTPoison.post!("#{@base_url}#{endpoint}",
                              [],
                              headers
        )

    case response.status_code do
      204 ->
        {:ok, "Skipped to previous track."}
      _ ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:error, %{"status" => response.status_code, "message" => decoded_response["error"]["message"]}}
    end
  end

  def seek_to_position(access_token, position_ms) do
    endpoint = "v1/me/player/seek"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response =
      HTTPoison.put!("#{@base_url}#{endpoint}?position_ms=#{position_ms}",
                              [],
                              headers
        )

    case response.status_code do
      204 ->
        {:ok, "Seeked to position #{position_ms}."}
      _ ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:error, %{"status" => response.status_code, "message" => decoded_response["error"]["message"]}}
    end
  end

  def set_playback_volume(access_token, volume_percent) do
    endpoint = "v1/me/player/volume"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response =
      HTTPoison.put!("#{@base_url}#{endpoint}?volume_percent=#{volume_percent}",
                              [],
                              headers
        )

    case response.status_code do
      204 ->
        {:ok, "Playback volume set to #{volume_percent}%."}
      _ ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        {:error, %{"status" => response.status_code, "message" => decoded_response["error"]["message"]}}
    end
  end
end

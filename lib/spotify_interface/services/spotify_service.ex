defmodule SpotifyInterface.Services.SpotifyService do
  alias SpotifyInterface.Album.Album
  alias SpotifyInterface.Artist.Artist
  alias SpotifyInterface.Track.Track

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

        artists = Enum.map(decoded_response["artists"]["items"], fn artist ->
          %Artist{
            external_urls: artist["external_urls"],
            followers_href: artist["followers"]["href"],
            total_followers: artist["followers"]["total"],
            genres: artist["genres"],
            genres_href: artist["href"],
            id: artist["id"],
            images: artist["images"],
            name: artist["name"],
            popularity: artist["popularity"],
            type: artist["type"],
            uri: artist["uri"]
          }
        end)

        albums = Enum.map(decoded_response["albums"]["items"], fn album ->
          %Album{
            album_type: album["album_type"],
            total_tracks: album["total_tracks"],
            available_markets: album["available_markets"],
            external_urls: album["external_urls"],
            href: album["href"],
            id: album["id"],
            images: album["images"],
            name: album["name"],
            release_date: album["release_date"],
            release_date_precision: album["release_date_precision"],
            restrictions: album["restrictions"],
            type: album["type"],
            uri: album["uri"],
            genres: album["genres"],
            label: album["label"],
            popularity: album["popularity"]
          }
        end)

        tracks = Enum.map(decoded_response["tracks"]["items"], fn track ->
          %Track{
            id: track["id"],
            available_markets: track["available_markets"],
            disc_number: track["disc_number"],
            duration_ms: track["duration_ms"],
            explicit: track["explicit"],
            external_ids: track["external_ids"],
            external_urls: track["external_urls"],
            href: track["href"],
            is_playable: track["is_playable"],
            linked_from: track["linked_from"],
            restrictions: track["restrictions"],
            name: track["name"],
            popularity: track["popularity"],
            preview_url: track["preview_url"],
            track_number: track["track_number"],
            type: track["type"],
            uri: track["uri"],
            is_local: track["is_local"],
            artists: track["artists"],
            album: track["album"]
          }
        end)

        %{
          artists: artists,
          albums: albums,
          tracks: tracks
        }
       _ ->
        {:error, %{"status" => response.status_code, "message" => response.body}}
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

        %Album{
          album_type: decoded_response["album_type"],
          total_tracks: decoded_response["total_tracks"],
          available_markets: decoded_response["available_markets"],
          external_urls: decoded_response["external_urls"],
          href: decoded_response["href"],
          id: decoded_response["id"],
          images: decoded_response["images"],
          name: decoded_response["name"],
          release_date: decoded_response["release_date"],
          release_date_precision: decoded_response["release_date_precision"],
          restrictions: decoded_response["restrictions"],
          type: decoded_response["type"],
          uri: decoded_response["uri"],
          genres: decoded_response["genres"],
          label: decoded_response["label"],
          popularity: decoded_response["popularity"]
        }
      _ ->
        {:error, %{"status" => response.status_code, "message" => response.body}}
    end
  end

  def get_album_tracks(id, access_token) do
    endpoint = "v1/albums"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}/tracks?market=ES", headers, [])

    case response.status_code do
      200 ->
        decoded_response = response
          |> Map.get(:body)
          |> Jason.decode!()

        Enum.map(decoded_response["items"], fn track ->
          %Track{
            id: track["id"],
            available_markets: track["available_markets"],
            disc_number: track["disc_number"],
            duration_ms: track["duration_ms"],
            explicit: track["explicit"],
            external_ids: track["external_ids"],
            external_urls: track["external_urls"],
            href: track["href"],
            is_playable: track["is_playable"],
            linked_from: track["linked_from"],
            restrictions: track["restrictions"],
            name: track["name"],
            popularity: track["popularity"],
            preview_url: track["preview_url"],
            track_number: track["track_number"],
            type: track["type"],
            uri: track["uri"],
            is_local: track["is_local"],
            artists: track["artists"],
            album: track["album"]
          }
        end)
      _ ->
        {:error, %{"status" => response.status_code, "message" => response.body}}
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

        %Artist{
          external_urls: decoded_response["external_urls"],
          followers_href: decoded_response["followers"]["href"],
          total_followers: decoded_response["followers"]["total"],
          genres: decoded_response["genres"],
          genres_href: decoded_response["href"],
          id: decoded_response["id"],
          images: decoded_response["images"],
          name: decoded_response["name"],
          popularity: decoded_response["popularity"],
          type: decoded_response["type"],
          uri: decoded_response["uri"]
        }
      _ ->
        {:error, %{"status" => response.status_code, "message" => response.body}}
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

        Enum.map(decoded_response["items"], fn album ->
          %Album{
            album_type: album["album_type"],
            total_tracks: album["total_tracks"],
            available_markets: album["available_markets"],
            external_urls: album["external_urls"],
            href: album["href"],
            id: album["id"],
            images: album["images"],
            name: album["name"],
            release_date: album["release_date"],
            release_date_precision: album["release_date_precision"],
            restrictions: album["restrictions"],
            type: album["type"],
            uri: album["uri"],
            genres: album["genres"],
            label: album["label"],
            popularity: album["popularity"]
          }
        end)
      _ ->
        {:error, %{"status" => response.status_code, "message" => response.body}}
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

        Enum.map(decoded_response["tracks"], fn track ->
          %Track{
            id: track["id"],
            available_markets: track["available_markets"],
            disc_number: track["disc_number"],
            duration_ms: track["duration_ms"],
            explicit: track["explicit"],
            external_ids: track["external_ids"],
            external_urls: track["external_urls"],
            href: track["href"],
            is_playable: track["is_playable"],
            linked_from: track["linked_from"],
            restrictions: track["restrictions"],
            name: track["name"],
            popularity: track["popularity"],
            preview_url: track["preview_url"],
            track_number: track["track_number"],
            type: track["type"],
            uri: track["uri"],
            is_local: track["is_local"],
            artists: track["artists"],
            album: track["album"]
          }
        end)
      _ ->
        {:error, %{"status" => response.status_code, "message" => response.body}}
    end
  end
end

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
    |> Map.get(:body)
    |> Jason.decode!()

    if response["error"] do
      {:error, response["error"]}
    else
      artists = Enum.map(response["artists"]["items"], fn artist ->
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

      albums = Enum.map(response["albums"]["items"], fn album ->
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

      tracks = Enum.map(response["tracks"]["items"], fn track ->
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
    end
  end

  def get_album(id, access_token) do
    endpoint = "v1/albums"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}?market=ES", headers, [])
    |> Map.get(:body)
    |> Jason.decode!()

    if response["error"] do
      {:error, response["error"]}
    else
      %Album{
        album_type: response["album_type"],
        total_tracks: response["total_tracks"],
        available_markets: response["available_markets"],
        external_urls: response["external_urls"],
        href: response["href"],
        id: response["id"],
        images: response["images"],
        name: response["name"],
        release_date: response["release_date"],
        release_date_precision: response["release_date_precision"],
        restrictions: response["restrictions"],
        type: response["type"],
        uri: response["uri"],
        genres: response["genres"],
        label: response["label"],
        popularity: response["popularity"]
      }
    end
  end

  def get_album_tracks(id, access_token) do
    endpoint = "v1/albums"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}/tracks?market=ES", headers, [])
    |> Map.get(:body)
    |> Jason.decode!()

    if response["error"] do
      {:error, response["error"]}
    else
      Enum.map(response["items"], fn track ->
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
    end
  end

  def get_artist(id, access_token) do
    endpoint = "v1/artists"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}", headers, [])
    |> Map.get(:body)
    |> Jason.decode!()

    if response["error"] do
      {:error, response["error"]}
    else
      %Artist{
        external_urls: response["external_urls"],
        followers_href: response["followers"]["href"],
        total_followers: response["followers"]["total"],
        genres: response["genres"],
        genres_href: response["href"],
        id: response["id"],
        images: response["images"],
        name: response["name"],
        popularity: response["popularity"],
        type: response["type"],
        uri: response["uri"]
      }
    end
  end

  def get_albums_by_artist(id, access_token) do
    endpoint = "v1/artists"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}/albums?market=ES", headers, [])
    |> Map.get(:body)
    |> Jason.decode!()

    if response["error"] do
      {:error, response["error"]}
    else
      Enum.map(response["items"], fn album ->
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
    end
  end

  def get_top_tracks_by_artist(id, access_token) do
    endpoint = "v1/artists"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}/top-tracks?market=ES", headers, [])
    |> Map.get(:body)
    |> Jason.decode!()

    if response["error"] do
      {:error, response["error"]}
    else
      Enum.map(response["tracks"], fn track ->
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
    end
  end
end

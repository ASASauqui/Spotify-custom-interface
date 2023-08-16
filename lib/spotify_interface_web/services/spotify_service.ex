defmodule SpotifyInterfaceWeb.Services.SpotifyService do
  alias SpotifyInterface.Album.Album
  alias SpotifyInterface.Artist.Artist
  alias SpotifyInterface.Track.Track
  alias SpotifyInterface.Image.Image

  # This is not my API key, it's just a test one.
  @spotify_token "BQCm0zDFI6kP5xcCeJWE9OmSdfzfpCXYU7Xrwqd8OeT0ihhjV8gEKYThCw2Y_xu_SFSg4OLGXwfjbZqDRdwAz7LFBbYOgbMo4wB0gZDElFHuDnymQ8NVlKXTsZgvQm6shrgJyKuSzuvQ3SwLgzHbSl1v1BpY7kMtjbEZdOpIEUT2ecJ5cEtdy5tgUdywWIw71Lpha4T1kNPcJse71wexhMDY-9b10NBKnMEMdBMLq7JrbHJ_q0cBGyaxomMkY45O9QoCGAiSz0JBC-KgUxWQ"
  @base_url "https://api.spotify.com/"

  def search_for_item(search) do
    endpoint = "v1/search"
    headers = [{"Authorization", "Bearer #{@spotify_token}"}]

    encoded_search = URI.encode_www_form(search)

    response = HTTPoison.get!("#{@base_url}#{endpoint}?q=#{encoded_search}&type=album%2Cartist%2Ctrack&market=ES", headers, [])
    |> Map.get(:body)
    |> Jason.decode!()

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

  def get_album(id) do
    endpoint = "v1/albums"
    headers = [{"Authorization", "Bearer #{@spotify_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}?market=ES", headers, [])
    |> Map.get(:body)
    |> Jason.decode!()

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

  def get_album_tracks(id) do
    endpoint = "v1/albums"
    headers = [{"Authorization", "Bearer #{@spotify_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}/tracks?market=ES", headers, [])
    |> Map.get(:body)
    |> Jason.decode!()

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

  def get_artist(id) do
    endpoint = "v1/artists"
    headers = [{"Authorization", "Bearer #{@spotify_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}", headers, [])
    |> Map.get(:body)
    |> Jason.decode!()

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

  def get_albums_by_artist(id) do
    endpoint = "v1/artists"
    headers = [{"Authorization", "Bearer #{@spotify_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}/albums?market=ES", headers, [])
    |> Map.get(:body)
    |> Jason.decode!()

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

  def get_top_tracks_by_artist(id) do
    endpoint = "v1/artists"
    headers = [{"Authorization", "Bearer #{@spotify_token}"}]

    response = HTTPoison.get!("#{@base_url}#{endpoint}/#{id}/top-tracks?market=ES", headers, [])
    |> Map.get(:body)
    |> Jason.decode!()

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

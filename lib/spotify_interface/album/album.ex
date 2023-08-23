defmodule SpotifyInterface.Album.Album do
  use Ecto.Schema

  schema "album" do
    field :album_type, :string
    field :total_tracks, :integer
    field :available_markets, {:array, :string}
    field :external_urls, :map
    field :href, :string
    field :name, :string
    field :release_date, :string
    field :release_date_precision, :string
    field :restrictions, :map
    field :type, :string
    field :uri, :string
    field :genres, {:array, :string}
    field :label, :string
    field :popularity, :integer
    field :tracks, :map
    has_many :artists, SpotifyInterface.Artist.Artist
    has_many :images, SpotifyInterface.Image.Image
  end
end

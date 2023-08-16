defmodule SpotifyInterface.Track.Track do
  use Ecto.Schema

  schema "track" do
    field :available_markets, {:array, :string}
    field :disc_number, :integer
    field :duration_ms, :integer
    field :explicit, :boolean
    field :external_ids, :map
    field :external_urls, :map
    field :href, :string
    field :is_playable, :boolean
    field :linked_from, :map
    field :restrictions, :map
    field :name, :string
    field :popularity, :integer
    field :preview_url, :string
    field :track_number, :integer
    field :type, :string
    field :uri, :string
    field :is_local, :boolean
    has_many :artists, SpotifyInterface.Artist.Artist
    has_one :album, SpotifyInterface.Album.Album
  end
end

defmodule SpotifyInterface.Artist.Artist do
  use Ecto.Schema

  schema "artist" do
    field :external_urls, :map
    field :followers_href, :string
    field :total_followers, :integer
    field :genres, {:array, :string}
    field :genres_href, :string
    field :name, :string
    field :popularity, :integer
    field :type, :string
    field :uri, :string
    has_many :images, SpotifyInterface.Image.Image
  end
end

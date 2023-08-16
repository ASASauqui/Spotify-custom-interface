defmodule SpotifyInterface.Image.Image do
  use Ecto.Schema

  schema "image" do
    field :url, :string
    field :height, :integer
    field :width, :integer
  end
end

defmodule SpotifyInterface.Crypto.CodeChallenge do
  def generate_code_challenge(code_verifier) do
    :crypto.hash(:sha256, code_verifier)
    |> Base.url_encode64(padding: false)
  end
end

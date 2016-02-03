defmodule Atbash do
  @cypher %{
    "a" => "z", "b" => "y", "c" => "x", "d" => "w",
    "e" => "v", "f" => "u", "g" => "t", "h" => "s",
    "i" => "r", "j" => "q", "k" => "p", "l" => "o",
    "m" => "n", "n" => "m", "o" => "l", "p" => "k",
    "q" => "j", "r" => "i", "s" => "h", "t" => "g",
    "u" => "f", "v" => "e", "w" => "d", "x" => "c",
    "y" => "b", "z" => "a"
  }

  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t) :: String.t
  def encode(plaintext) do
    plaintext
      |> String.downcase
      |> String.replace(~r/\W/, "")
      |> String.graphemes
      |> Enum.map(&(@cypher[&1] || &1))
      |> Enum.chunk(5, 5, [nil, nil, nil, nil, nil])
      |> Enum.map(&(Enum.join(&1)))
      |> Enum.join(" ")
  end
end

defmodule RunLengthEncoder do 
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "HORSE" => "1H1O1R1S1E"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form. 
  "1H1O1R1S1E" => "HORSE" 
  """
  @spec encode(string) :: String.t
  def encode(string) do
    string |> String.graphemes |> Enum.reduce({nil, nil, ""}, fn(character, {previous, count, acc}) ->
      cond do
        character == previous ->
          {previous, count + 1, acc}
        true ->
          {character, 1, acc <> "#{count}#{previous}"}
      end
    end) |> (fn({last, count, acc}) -> acc <> "#{count}#{last}" end).()
  end

  @spec decode(string) :: String.t
  def decode(string) do
    string |> String.graphemes |> Enum.reduce({"", ""}, fn(character, {number, acc}) ->
      cond do
        Regex.match?(~r/\d/, character) ->
          {number <> character, acc}
        true ->
          letters = Stream.repeatedly(fn -> character end) |> Enum.take(String.to_integer(number)) |> Enum.join
          {"", acc <> letters}
      end
    end) |> elem(1)
  end
end

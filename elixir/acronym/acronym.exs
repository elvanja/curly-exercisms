defmodule Acronym do
  @doc """
  Generate an acronym from a string. 
  "This is a string" => "TIAS"
  """
  @spec abbreviate(string) :: String.t()
  def abbreviate(string) do
    string |> String.split |> Enum.map(&acronym/1) |> Enum.join
  end

  defp acronym(word) do
    word |> String.graphemes |> Enum.with_index |> Enum.filter(fn({character, index}) ->
      index == 0 || Regex.match?(~r/[A-Z]/, character)
    end) |> Enum.map(&(elem(&1, 0))) |> Enum.join |> String.upcase
  end
end

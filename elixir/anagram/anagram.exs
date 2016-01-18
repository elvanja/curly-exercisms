defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t, [String.t]) :: [String.t]
  def match(base, candidates) do
    candidates |> Enum.filter(fn(candidate) ->
      !equal?(base, candidate) && anagram?(base, candidate)
    end)
  end

  defp equal?(base, candidate) do
    String.downcase(base) == String.downcase(candidate)
  end

  defp anagram?(base, candidate) do
    hash(base) == hash(candidate)
  end

  defp hash(string) do
    string |> String.downcase |> String.split("") |> Enum.sort
  end
end

defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t) :: map()
  def count(sentence) do
    sentence |> String.downcase |> clean_up |> String.split |> group_by_word |> count_grouped |> Enum.into(%{})
  end

  defp clean_up(sentence) do
    String.replace(sentence, ~r/[_:,!?@$%^&]/, " ")
  end

  defp group_by_word(words) do
    Enum.group_by(words, fn(word) -> word end)
  end

  defp count_grouped(words) do
    Enum.map(words, fn({word, list}) -> {word, length(list)} end)
  end
end

defmodule Bob do
  defp is_empty?(statement) do
    statement == ""
  end

  defp is_question?(statement) do
    String.ends_with?(statement, "?")
  end

  defp is_shouting?(statement) do
    statement == String.upcase(statement) && String.replace(statement, ~r/\d+/, "") |> String.match?(~r/\w+/)
  end

  def hey(statement) do
    statement = String.strip(statement)
    cond do
      is_empty?(statement) -> "Fine. Be that way!"
      is_question?(statement) -> "Sure."
      is_shouting?(statement) -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end
end

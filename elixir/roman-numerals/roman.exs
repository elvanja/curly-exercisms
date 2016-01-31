defmodule Roman do
  @roman_values [
    {1000, "M"},
    {900, "CM"},
    {500, "D"},
    {400, "CD"},
    {100, "C"},
    {90, "XC"},
    {50, "L"},
    {40, "XL"},
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
  ]

  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t
  def numerals(0) do
    ""
  end
  def numerals(number) do
    @roman_values |> Enum.find(fn({arabic, roman}) -> number >= arabic end) |> fn({arabic, roman}) ->
      roman <> numerals(number - arabic)
    end.()
  end
end

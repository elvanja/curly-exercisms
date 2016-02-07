defmodule Palindromes do

  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map() 
  def generate(max_factor, min_factor \\ 1) do
    palindromes = for a <- min_factor..max_factor,
                      b <- a..max_factor,
                      product = a * b,
                      palindrome?(product),
                      do: {product, [a, b]}
           
    #palindromes
    #  |> Enum.group_by(fn({product, pair}) -> product end)
    #  |> Enum.map(fn({product, products}) -> {product, Dict.values(products) |> Enum.reverse} end)
    #  |> Enum.into(%{})
    palindromes |> Enum.reduce(%{}, fn({product, pair}, acc) ->
      acc |> Map.update(product, [pair], &(&1 ++ [pair]))
    end)
  end

  def palindrome?(number) do
    as_string = number |> Integer.to_string
    as_string == as_string |> String.reverse
  end
end

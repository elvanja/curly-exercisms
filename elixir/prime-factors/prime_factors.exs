defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest. 
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(1) do
    []
  end
  def factors_for(number) do
    factors_for(number, 2, [])
  end
  defp factors_for(number, divisor, acc) when number < divisor * divisor do
    acc |> Enum.reverse([number])
  end
  defp factors_for(number, divisor, acc) when rem(number, divisor) == 0 do
    factors_for(div(number, divisor), divisor, [divisor | acc])
  end
  defp factors_for(number, divisor, acc) do
    factors_for(number, divisor + 1, acc)
  end
end

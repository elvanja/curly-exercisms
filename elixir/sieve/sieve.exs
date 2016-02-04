defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    2..limit |> Enum.to_list |> sieve |> Enum.filter(&(&1 != :not_prime))
  end

  defp sieve([]) do
    []
  end
  defp sieve([h|t]) when h == :not_prime do
    [h | t |> sieve]
  end
  defp sieve([h|t]) do
    [h | t |> Enum.with_index |> Enum.map(fn({number, index}) ->
      if rem(index + 1, h) == 0, do: :not_prime, else: number
    end) |> sieve]
  end
end

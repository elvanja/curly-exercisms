defmodule Raindrops do
  Code.load_file("../prime-factors/prime_factors.exs")

  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t
  def convert(number) do
    factors = PrimeFactors.factors_for(number) |> Enum.map(fn(factor) ->
      case factor do
        3 -> "Pling"
        5 -> "Plang"
        7 -> "Plong"
        _ -> nil
      end
    end) |> Enum.reject(&(&1 == nil)) |> Enum.uniq

    if Enum.empty?(factors), do: "#{number}", else: factors |> Enum.join
  end
end

defmodule Grains do
  use Bitwise
  
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) do
    bsl(1, number - 1)
  end

  # returns correct results
  # but, for very large numbers is slow, e.g. 1.2 seconds for square(262144)
  def square_with_reduce(number) do
    1..number |> Enum.reduce(fn(x, acc) -> acc * 2 end)
  end
  
  # returns correct results as well
  # but, throws (ArithmeticError) bad argument in arithmetic expression for large numbers, e.g. 32768
  def square_with_pow(number) do
    :math.pow(2, number - 1) |> round
  end

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    square(65) - 1
  end
end

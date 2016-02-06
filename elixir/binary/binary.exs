defmodule Binary do
  use Bitwise

  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t) :: non_neg_integer
  def to_decimal(string) do
    if String.match?(string, ~r/[^10]/) do
  		0
    else
      string |> String.graphemes |> Enum.reverse |> Enum.with_index |> Enum.map(&pow_two/1) |> Enum.sum
    end
  end

  defp pow_two({"0", _}) do
    0
  end
  defp pow_two({"1", power}) do
    bsl(1, power)
  end
end

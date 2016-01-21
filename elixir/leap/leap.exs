defmodule Year do
  @doc """
  Returns whether 'year' is a leap year.

  A leap year occurs:

  on every year that is evenly divisible by 4
    except every year that is evenly divisible by 100
      except every year that is evenly divisible by 400.
  """
  @spec leap_year?(non_neg_integer) :: boolean
  def leap_year?(year) do
    case rem(year, 4) do
      0 when rem(year, 100) != 0 ->
        true
      0 when rem(year, 400) == 0 ->
        true
      _ ->
        false
    end
  end
end

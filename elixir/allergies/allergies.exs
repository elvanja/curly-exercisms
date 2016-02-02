defmodule Allergies do
  import Bitwise

  @allergies %{
    1 => "eggs",
    2 => "peanuts",
    4 => "shellfish",
    8 => "strawberries",
    16 => "tomatoes",
    32 => "chocolate",
    64 => "pollen",
    128 => "cats"
  }

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t]
  def list(flags) do
    @allergies |> Enum.filter(fn({flag, _}) ->
      (flags &&& flag) != 0
    end) |> Dict.values
  end
  
  # an alternative implementation, using Stream.unfold/2
  def list_with_unfold(flags) do
    Stream.unfold({flags, @allergies |> Enum.max |> elem(0)}, fn({_, 0}) -> nil; ({remaining, flag}) ->
      if flag <= remaining do
        {@allergies[flag], {remaining - flag, flag}}
      else
        {nil, {remaining, Bitwise.bsr(flag, 1)}}
      end
    end) |> Enum.to_list |> Enum.reject(&(!&1))
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t) :: boolean
  def allergic_to?(flags, item) do
    list(flags) |> Enum.member?(item)
  end
end

defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
      :monday | :tuesday | :wednesday
    | :thursday | :friday | :saturday | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  #TODO see if there is a way to map from type, e.g. Meetup.weekday |> Enum.with_index(1) |> Enum.into(%{})
  @weekdays %{:monday => 1, :tuesday => 2, :wednesday => 3, :thursday => 4, :friday => 5, :saturday => 6, :sunday => 7}
  
  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date
  def meetup(year, month, weekday, schedule) do
    matching_weekdates = 1..:calendar.last_day_of_the_month(year, month) |> Enum.map(&({year, month, &1})) |> Enum.filter(&(matches_weekday?(&1, weekday)))
    filter_by_schedule(matching_weekdates, schedule)
  end

  defp matches_weekday?(date, weekday) do
    :calendar.day_of_the_week(date) == @weekdays[weekday]
  end
  
  defp filter_by_schedule(dates, schedule) do
    #TODO see if there is a way to use this map as a constant, like @weekdays, problem due to unknown methods at constant declaration time
    apply(%{:first => &first/1, :second => &second/1, :third => &third/1, :fourth => &fourth/1, :last => &last/1, :teenth => &teenth/1}[schedule], [dates])
  end

  defp first(dates) do
    dates |> hd
  end

  defp second(dates) do
    dates |> Enum.at(1)
  end

  defp third(dates) do
    dates |> Enum.at(2)
  end

  defp fourth(dates) do
    dates |> Enum.at(3)
  end

  defp last(dates) do
    dates |> Enum.reverse |> hd
  end

  defp teenth(dates) do
    dates |> Enum.find(fn({_, _, day}) ->
      day >= 13 && day <= 19
    end)
  end
end

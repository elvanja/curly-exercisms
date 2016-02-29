defmodule Minesweeper do

  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t]) :: [String.t]

  def annotate(board) do
    matrix = board |> to_matrix
    matrix |> count |> merge(matrix) |> from_matrix
  end

  defp to_matrix(board) do
    board |> Enum.map(&(String.graphemes(&1)))
  end

  defp from_matrix(matrix) do
    matrix |> Enum.map(&(Enum.join(&1)))
  end

  defp merge(counts, matrix) do
    Enum.zip(matrix, counts)
    |> Enum.map(fn({original, counts}) ->
      Enum.zip(original, counts)
    end)
    |> Enum.map(&(&1 |> Enum.map(fn({bomb, count}) ->
      cond do
        bomb == "*" ->
          "*"
        count == 0 ->
          " "
        true ->
          count
      end
    end)))
  end

  defp count(matrix) do
    [
      matrix |> shift_left,
      matrix |> shift_left |> shift_up,
      matrix |> shift_left |> shift_down,
      matrix |> shift_right,
      matrix |> shift_right |> shift_up,
      matrix |> shift_right |> shift_down,
      matrix |> shift_up,
      matrix |> shift_down
    ]
    |> List.zip
    |> Enum.map(&(&1 |> Tuple.to_list |> List.zip |> count_per_position))
  end

  defp count_per_position(positions) do
    positions |> Enum.map(&(&1 |> Tuple.to_list |> List.flatten |> Enum.filter(fn(c) -> c == "*" end) |> length))
  end

  defp shift_left(matrix) do
    matrix |> Enum.map(&(shift_column(&1)))
  end

  defp shift_right(matrix) do
    matrix |> Enum.map(&(&1 |> Enum.reverse |> shift_column |> Enum.reverse))
  end

  defp shift_column([_|t]) do
    t ++ [" "]
  end

  defp shift_up(matrix) do
    matrix |> shift_row
  end

  defp shift_down(matrix) do
    matrix |> Enum.reverse |> shift_row |> Enum.reverse
  end

  defp shift_row([]) do
    []
  end
  defp shift_row([h|t]) do
    t ++ [Enum.map(h, fn(_) -> " " end)]
  end
end

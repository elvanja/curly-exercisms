defmodule Frequency do
  @doc """
  Count word frequency in parallel.

  Returns a dict of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t], pos_integer) :: Dict.t
  def frequency(texts, workers) do
    texts
      |> by_workers(workers)
      |> Enum.map(fn(texts) ->
        Task.async(fn -> frequencies(texts) end)
      end)
      |> Enum.map(&(Task.await(&1, 10000)))
      |> merge_results
  end

  defp by_workers(texts, workers) do
    texts
      |> Enum.with_index
      |> Enum.group_by(fn({_, index}) -> rem(index, workers) end)
      |> Dict.values
      |> Enum.map(&(Dict.keys(&1)))
  end

  defp frequencies(texts) when is_list(texts) do
    texts |> Enum.map(&(frequencies(&1))) |> merge_results
  end
  defp frequencies(text) do
    text
      |> String.downcase
      |> String.replace(~r/[_:,!?@$%^&\s\d]/, "")
      |> String.graphemes
      |> Enum.group_by(&(&1))
      |> Enum.map(fn({letter, list}) -> {letter, length(list)} end)
      |> Enum.into(%{})
  end

  defp merge_results(frequencies) do
    frequencies |> Enum.reduce(%{}, fn(frequencies, acc) ->
      Map.merge(acc, frequencies, fn(_, f1, f2) -> f1 + f2 end)
    end)
  end
end

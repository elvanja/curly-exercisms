defmodule DNA do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> DNA.count('AATAA', ?A)
  4

  iex> DNA.count('AATAA', ?T)
  1
  """
  @spec count([char], char) :: non_neg_integer
  def count(strand, nucleotide) do
    nucleotide!(nucleotide)
    strand |> strand! |> count_wo_check(nucleotide)
  end
  
  # optimization, so subsequent counts for same strand need not validate all over again
  defp count_wo_check(strand, nucleotide) do
    strand |> Enum.count(fn(n) -> n == nucleotide end)
  end

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> DNA.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram([char]) :: Dict.t
  def histogram(strand) do
    strand!(strand)
    @nucleotides |> Enum.reduce(%{}, fn(n, acc) -> Map.put(acc, n, count_wo_check(strand, n)) end)
  end

  # another take on histogram
  def histogram_with_zip(strand) do
    strand!(strand)
    Enum.zip(@nucleotides, Enum.map(@nucleotides, &(count_wo_check(strand, &1)))) |> Enum.into(%{})
  end

  defp strand!(strand) do
    strand |> Enum.map(&(nucleotide!(&1)))
  end
  
  defp nucleotide!(nucleotide) do
    if !Enum.member?(@nucleotides, nucleotide) do
      raise ArgumentError
    end
    nucleotide
  end
end

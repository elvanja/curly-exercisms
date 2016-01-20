defmodule DNA do
  @dna_rna_map %{?G => ?C, ?C => ?G, ?T => ?A, ?A => ?U}

  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> DNA.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    dna |> Enum.map(&(@dna_rna_map[&1]))
  end
end

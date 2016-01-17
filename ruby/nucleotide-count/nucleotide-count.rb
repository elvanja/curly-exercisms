class DNA
  # http://en.wikipedia.org/wiki/Nucleotide
  # http://en.wikipedia.org/wiki/RNA#Comparison_with_DNA
  DNA_NUCLEOTIDES = ['A', 'C', 'G', 'T']
  ALL_NUCLEOTIDES = DNA_NUCLEOTIDES + ['U']

  attr_reader :nucleotides
  alias_method :nucleotide_counts, :nucleotides

  def initialize(dna_string)
    build_nucleotides
    count_all(dna_string)
  end

  def count(nucleotide)
    nucleotides[validate(nucleotide, ALL_NUCLEOTIDES)] || 0
  end

  private

  def build_nucleotides
    @nucleotides = Hash[DNA_NUCLEOTIDES.map { |nucleotide| [nucleotide, 0] }]
  end

  def count_all(dna_string)
    dna_string.chars.each { |nucleotide| nucleotides[validate(nucleotide)] += 1 }
  end

  def validate(nucleotide, valid_nucleotides = DNA_NUCLEOTIDES)
    valid_nucleotides.include?(nucleotide) ? nucleotide : (raise ArgumentError.new)
  end
end
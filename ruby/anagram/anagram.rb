###############################################
# open to change by anagram calculating policy
# does not compute everything for the original every time
# downcase and hash explicit
###############################################

class NotEqualCaseInsensitiveAnagramPolicy
  attr_reader :word
  attr_reader :hash

  def initialize(word)
    @word = normalize(word)
    @hash = calculate_hash
  end

  def ==(anOther)
    word != anOther.word && hash == anOther.hash
  end

  private

  def calculate_hash
    word.split("").sort.join
  end


  def normalize(word)
    word.to_s.downcase
  end
end

class Anagram
  def initialize(word, policy = NotEqualCaseInsensitiveAnagramPolicy)
    @policy = policy
    @original = @policy.new(word)
  end

  def match(candidates)
    candidates.select { |candidate| @original == @policy.new(candidate) }
  end
end

###############################################
# open to change by anagram calculating policy
# evaluates everything for the original every time
# downcase and hash explicit
###############################################

class DiscardEqualsCaseInsensitiveAnagramPolicy
  def initialize(original, candidate)
    @original = normalize(original)
    @candidate = normalize(candidate)
  end

  def match?
    !equal && hash(@original) == hash(@candidate)
  end

  private

  def normalize(word)
    word.to_s.downcase
  end

  def equal
    @original == @candidate
  end

  def hash(word)
    word.split("").sort.join
  end
end

class PolicyAnagram
  def initialize(word, policy = DiscardEqualsCaseInsensitiveAnagramPolicy)
    @word, @policy = word, policy
  end

  def match(candidates)
    candidates.select { |candidate| @policy.new(@word, candidate).match? }
  end
end

###############################################
# short
# not open to change
# downcase repeated
###############################################

class CompactAnagram
  def initialize(word)
    @word = word
  end

  def match(candidates)
    hash = hash(@word)
    candidates.select { |candidate| !equal(candidate) && hash(candidate) == hash }
  end

  private

  def equal(candidate)
    @word.downcase == candidate.downcase
  end

  def hash(word)
    word.downcase.split("").sort.join
  end
end
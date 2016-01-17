class Phrase
  def initialize(sentence)
    @sentence = sentence.to_s
  end

  def word_count
    count(words)
  end

  private

  def words
    @sentence.downcase.scan(/\w+/)
  end

  def count(words)
    words.each_with_object(Hash.new(0)) { |word, count| count[word] += 1 }
  end
end

class PhraseWithPrepare
  def initialize(sentence)
    @sentence = prepare(sentence)
  end

  def word_count
    count(words)
  end

  private

  def prepare(sentence)
    sentence.to_s.downcase
  end

  def words
    @sentence.scan(/\w+/)
  end

  def count(words)
    words.each_with_object(Hash.new(0)) { |word, count| count[word] += 1 }
  end
end
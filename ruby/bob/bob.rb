class Behaviour
  DEFAULT_RESPONSE = 'Whatever.'

  def initialize(next_link = nil)
    @next_link = next_link
  end

  def respond_to(interaction)
    return response if matches?(interaction)
    @next_link ? @next_link.respond_to(interaction) : DEFAULT_RESPONSE
  end

  private

  def empty?(interaction)
    interaction.nil? || interaction.strip.empty?
  end

  def matches?(interaction)
    raise NameError.new("should be implemented in concrete implementation")
  end

  def response
    raise NameError.new("should be implemented in concrete implementation")
  end
end

class SilentBehaviour < Behaviour
  def matches?(interaction)
    empty?(interaction)
  end

  def response
    'Fine. Be that way!'
  end
end

class ShoutingBehaviour < Behaviour
  def matches?(interaction)
    empty?(interaction) ? false : interaction.upcase == interaction
  end

  def response
    'Woah, chill out!'
  end
end

class QuestionBehaviour < Behaviour
  def matches?(interaction)
    empty?(interaction) ? false : interaction.end_with?('?')
  end

  def response
    'Sure.'
  end
end

class Bob
  def hey(interaction, behaviour = default_behaviour)
    behaviour.respond_to(interaction)
  end

  private

  def default_behaviour
    SilentBehaviour.new(ShoutingBehaviour.new(QuestionBehaviour.new))
  end
end
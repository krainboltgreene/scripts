class Dragon

  DICTIONARY = []
  DEFAULTS = {}

  attr_accessor :dictionary

  def initialize
    @dictionary = DICTIONARY.dup
  end

  def parse(source, options = {})
    raise TypeError unless source.is_a? Hash
    options.merge! DEFAULTS
    if source.keys.first != :add_word
      trigger_word(source.keys.first, source.values.first)
    else
      send source.keys.first, source.values.first
    end
  end

  private

    def trigger_word(word, *arguments)
      @dictionary[word].call *arguments
    end

    def add_word(formula)
      raise ArgumentError unless formula[0].is_a? Symbol
      raise ArgumentError unless formula[1].is_a? Proc
      @dictionary << formula
    end
end

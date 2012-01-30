require_relative 'dragon'


engine = Dragon.new

engine.parse add_word: [:sample, ->{"Hello"}]

engine.parse sample: nil

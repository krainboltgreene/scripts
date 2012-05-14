require 'benchmark'

class Classifier
  def initialize
    @docs = Hash.new(0)
    @words = {}
  end

  def train(words,tag)
    @docs[tag] += 1
    @words[tag] ||= Hash.new(1)
    words.each{|w| @words[tag][w] += 1 }
  end

  def classify(words)
    @data.keys.max_by do |tag|
      Math.log(@docs[tag]) +
      words.map{|w| Math.log(@words[tag][w])}.reduce(:+)
    end
  end
end

class Classifier2
  def initialize
    # Create an empty hash for tags, where the default value is 0
    @tags = Hash.new 0

    # Create an empty hash for words
    @words = {}
  end

  def train(words, tag)
    # Add the tag with a weight of 1 or increase the tag's weight
    @tags[tag] += 1

    # Add a new hash (default value of 1) for the tag, unless the tag has a value
    @words[tag] ||= Hash.new 1

    # Go over each item in the array of words
    # Access the @words hash, with the tag as the key
    # And then either add a key/value with the word as key (and the value of 2)
    # or increase the words weight
    words.each { |word| @words[tag][word] += 1 }
  end

  def classify(words)
    @tags.keys.max_by do |tag|
      Math.log(@tags[tag])
      words.map{ |word| Math.log @words[tag][word] }.reduce(:+)
    end
  end
end


# Benchmark.bmbm(10) do |x|
#   x.report("old:") do
#     classifier = Classifier.new
#     classifier.train ["Hello", "World", "Eve"], "Spam"
#   end
#   x.report("new:")  { Classifier2.new }
# end

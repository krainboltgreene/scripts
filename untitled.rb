require 'ostruct'

module Ruby
  class Action < OpenStruct
    def initialize(table)
      super(table)
      wrapped_source = ->(args) { fork { source } }
      scope.define_singleton_method name, wrapped_source
    end
  end

  class Type < OpenStruct
    def initialize(table)
      super(table)
      scope name, source
    end

    def include_concept(name)

    end

    def inherit_from(name)

    end
  end

  class Concept < OpenStruct
    def include_concept(name)

    end
  end


  def action(name, &block)
    raise ArgumentError unless block_given?
    raise ArgumentError unless name.is_a? Symbol
    Action.new name: name, source: block, scope: self
  end

  def type(name, &block)
    raise ArgumentError unless block_given?
    raise ArgumentError unless name.is_a? Symbol
    Type.new name: name, source: block, scope: self
  end

  def concept(name, &block)
    raise ArgumentError unless block_given?
    raise ArgumentError unless name.is_a? Symbol
    Concept.new name: name, source: block, scope: self
  end
end

include Ruby

action :outprint do |string|
  print string
end

# action(:output) { |*strings| puts strings }

outprint "Hello, World!\n"
# output "Helllloooo", "World!"

# type :stringly do
#   action :outprint2 do |string|
#     puts string
#   end
# end

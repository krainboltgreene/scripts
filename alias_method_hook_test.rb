require "pry"

module Hook
  def included
    @@__hooks__ = { before: [, after: [] }
  end

  def hook(event, name, &block)
    __hooks__[event] << block
    unless method_defined?("__#{name}__")
      alias_method("__#{name}__", name)
      define_method(name) do |*arguments|
        instance_exec(*arguments, self.class.__hooks__[:before])
        send("__#{name}__", *arguments)
        instance_exec(*arguments, self.class.__hooks__[:after])
      end
    end
  end

  def before(name, &block)
    hook(:before, name, &block)
  end

  def after(name, &block)
    hook(:after, name, &block)
  end
end

class Human
  extend Hook

  def initialize(name)
    @name = name
  end

  def name=(value)
    @name = value
  end
  before(:name=) do |value|
    value.is_a?(String)
  end

  def name
    @name
  end
end

person = Human.new("James")

person.name = 1

puts person.name

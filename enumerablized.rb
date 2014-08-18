class Students
  include Enumerable
  attr_reader :members

  def initialize(*names)
    @members = names.uniq
  end

  def each(&block)
    @members.each(&block)
  end

  def <<(item)
    @members.tap { @members.push(item) unless @members.includes?(item) }
  end

  undef :first
end

roll = Students.new("James", "Katie", "Mathews")
p roll.members
p roll.count
p roll.first

class Human
  def initialize(name)
    @name = name
  end

  def name
    formated(@name)
  end

  private

  def formated(text)
    text.downcase
  end

  protected

  def heartbeat
    3
  end
end

class Firefighter
  def initialize(name)
    @body = Human.new(name)
  end

  def heartbeat
    @body.heartbeat
  end

end

john = Firefighter.new("John Bart")
p john.heartbeat


module Human
  def feet
    2
  end

  def hands
    2
  end

  def era
    @era
  end

  def self.included(object)
    object.extend ClassMethods
  end

  module ClassMethods
    def born_around(range)
      @@era = range
    end
  end
end

module Firefighter
  def vehicle
    @vehicle ||= case era
      when 1100..1949 then Firewagon.new
      when 1950..2100 then Firetruck.new
    end
  end

  def willpower
    @willpower = 15
  end
end

module Weightlifter
  def physique
    @physique = 18
  end

  def willpower
    @willpower = 13
  end
end

class Person
  attr_accessor :name, :age, :gender
  include Human
  include Weightlifter
  include Firefighter

  born_around 1950..2100
  p self.class_variables
end

class Vehicle

end

class Firewagon < Vehicle

end

class Firetruck < Vehicle

end

kurtis = Person.new
kurtis.name = "Kurtis Rainbolt-Greene"
kurtis.age = 25
kurtis.gender = 1
p kurtis.vehicle

class Robot
  def initialize
    @arms = [Arm.new(self), Arm.new(self)]
  end

  def pickup(thing)
    @arms.first.pickup(thing)
  end

  class Arm
    def initialize(robot)
      @robot = robot
      @holding = nil
    end

    def pickup(thing)
      unless @holding
        @holding = thing
      end
    end
  end
end

require 'minitest/autorun'

describe Robot do
  describe "#initialize" do
    it "should start with two arms" do
      Robot::Arm.expect(:new)
      Robot.new
    end
  end
end

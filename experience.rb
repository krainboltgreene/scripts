class ExperienceCalculator
  attr_accessor :enemy_base_experience
  attr_accessor :level_of_losing_pokemon
  attr_accessor :number_of_pokemon_who_fought
  attr_accessor :level_of_winning_pokemon
  attr_writer :wild_battle
  attr_writer :ownership
  attr_writer :lucky_egg
  attr_writer :power_point

  def initialize(&block)
    instance_eval(&block)
  end

  def total
    top_left = wild_battle * enemy_base_experience * level_of_losing_pokemon
    bottom_left = 5 * number_of_pokemon_who_fought

    top_right = (2 * level_of_losing_pokemon + 10) ** 2.5
    bottom_right = (level_of_losing_pokemon + level_of_winning_pokemon) ** 2.5

    left = top_left / bottom_left
    right = top_right / bottom_right

    ((left * right + 1) + ownership + lucky_egg + power_point).round
  end

  private

  def sqrt(integer)
    Math.sqrt(integer)
  end

  def ownership
    case @ownership
      when "international" then 1.7
      when "domestic" then 1.5
      else 1
    end
  end

  def wild_battle
    if @wild_battle then 1 else 1.5 end
  end

  def power_point
    case @power_point
      when 3..5 then 2
      when 2 then 1.5
      when 1 then 1.2
      else 0
    end
  end

  def lucky_egg
    if @lucky_egg then 1.2 else 1 end
  end
end

calculator = ExperienceCalculator.new do |options|
  options.enemy_base_experience = 390
  options.level_of_losing_pokemon = 63
  options.number_of_pokemon_who_fought = 1
  options.level_of_winning_pokemon = 76
  options.wild_battle = false
  options.ownership = "original"
  options.lucky_egg = false
  options.power_point = 2
end
puts calculator.total
puts 7897

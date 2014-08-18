


class Pokemon
  def initialize(name, type, xp, attributes, ability, moves, item)
    @name = name
    @type = type
    @xp = xp
    @attributes = attributes
    @ability = ability
    @moves = moves
    @item = item
  end
end

class Item
  def self.[](name)

  end
end

class Type
  POWERFULL_DAMAGEE_MODIFIER = 4
  STRONG_DAMAGEE_MODIFIER = 2
  WEAK_DAMAGEE_MODIFIER = 0.5
  POWERLESS_DAMAGE_MODIFIER = 0

  private

  def type_modifier(damage, type)
    case type
      when DOMINATE then powerful(damage)
      when EFFECTIVE then powerful(damage)
      when INEFFECTIVE then powerful(damage)
      when IMMUNE then powerful(damage)
      else damage
    when
  end

  def powerful(damage)
    amplify(POWERFULL, damage)
  end

  def strong(damage)
    amplify(STRONG, damage)
  end

  def weak(damage)
    amplify(WEAK, damage)
  end

  def powerless(damage)
    amplify(POWERLESS, damage)
  end

  def amplify(modifier, damage)
    modifier * damage
  end

  module Light
    DOMINATE = Dark
    EFFECTIVE = Light
    INEFFECTIVE = Air
    IMMUNE = Dark
    EVOLVER = Item["Large Prism"]
  end

  module Dark
    DOMINATE = Water
    EFFECTIVE = Mental
    INEFFECTIVE = Ground
    IMMUNE = Water
    EVOLVER = Item["Candle Snuffer"]
  end

  module Water
    DOMINATE = Fire
    EFFECTIVE = Spirit
    INEFFECTIVE = Beast
    IMMUNE = Fire
    EVOLVER = Item["Shiny Pearl"]
  end

  module Fire
    DOMINATE = Air
    EFFECTIVE = Metal
    INEFFECTIVE = Mental
    IMMUNE = Air
    EVOLVER = Item["Burning Torch"]
  end

  module Air
    DOMINATE = Ground
    EFFECTIVE = Air
    INEFFECTIVE = Spirit
    IMMUNE = Ground
    EVOLVER = Item["Stone Flute"]
  end

  module Earth
    DOMINATE = Beast
    EFFECTIVE = Dark
    INEFFECTIVE = Metal
    IMMUNE = Beast
    EVOLVER = Item["Mossy Stone"]
  end

  module Beast
    DOMINATE = Mental
    EFFECTIVE = Water
    INEFFECTIVE = Light
    IMMUNE = Mental
    EVOLVER = Item["Sharp Tooth"]
  end

  module Mental
    DOMINATE = Spirit
    EFFECTIVE = Fire
    INEFFECTIVE = Dark
    IMMUNE = Spirit
    EVOLVER = Item["Meditation Crystal"]
  end

  module Spirit
    DOMINATE = Metal
    EFFECTIVE = Air
    INEFFECTIVE = Water
    IMMUNE = Metal
    EVOLVER = Item["Prayer Breads"]
  end

  module Metal
    DOMINATE = Light
    EFFECTIVE = Earth
    INEFFECTIVE = Fire
    IMMUNE = Light
    EVOLVER = Item["Ingot"]
  end
end

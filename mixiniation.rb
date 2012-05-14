class Thing
  def self.mixin(*klasses)
    for klass in klasses
      @@mixins ||= []
      @@mixins = [klass] + @@mixins
    end
  end

  def method_missing(method, *arguments, &block)
    for mixin in @@mixins
      if mixin.method_defined? method
        return mixin.new.__send__ method, *arguments, &block
      end
    end

   error_message =  %| { "method": "#{method}", "args": "#{arguments.inspect}", "context": "#{self.class.to_s}" } |
   raise NoMethodError, error_message
  end
end

class CIA < Thing
  def badge_id
    "CIA Agent #1"
  end
end

class Officer < Thing
  def badge_id(name)
    "Officer #1, #{name}"
  end
end

class NewOrleans < Thing
  def party_time?
    true
  end
end

class Person < Thing
  mixin CIA
  mixin NewOrleans
  mixin Officer
end

john = Person.new

p john.badge_id "Kurtis Rainbolt-Greene"
p john.party_time?
p john.knock_knock_joke ["Hello"]

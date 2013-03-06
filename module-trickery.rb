module Alpha
  def self.included(object)
    object.extend ClassMethods
  end

  module ClassMethods
    def example_method
      print "Hello."
    end
  end
end

module Beta
end

Beta.send :include, Alpha

module Delta
  include Beta
end

class Omega
  include Delta
end

class Capa < Omega
  example_method
end

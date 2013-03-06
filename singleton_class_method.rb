# class Thing
#   def test

#   end
#   def example
#     self.class.instance_eval { remove_method :test }
#   end
# end

# t = Thing.new
# p t.public_methods

# p t.example

# p t.public_methods
class Thing
  def example1

  end

  def example2

  end

end

athing = Thing.new

p athing.public_methods.include? :example1 #=> true
p athing.public_methods.include? :example2 #=> true
p athing

p athing.class.send :remove_method, :example1
p athing.public_methods.include? :example1 #=> true
p athing

class Foo
  def self.blah
    puts self
  end
  class Far < Foo
  end
end


Foo::Far.blah

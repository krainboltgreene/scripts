module Example
  def method1

  end

  private

  def method2

  end
end

class Thing
  include Example
end

class Thong
  extend Example
end

module Exomple
  include Example
end

p Example.public_instance_methods.include? :method1 # true
p Example.private_instance_methods.include? :method2 # true
p Thing.public_instance_methods.include? :method1 # true
p Thing.private_instance_methods.include? :method2 # true
p Thong.singleton_methods.include? :method1 # true
p Thong.public_methods.include? :method1 # true
p Thong.private_methods.include? :method2 # true
p Exomple.public_instance_methods.include? :method1 # true
p Exomple.private_instance_methods.include? :method2 # true

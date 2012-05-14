class Rubinius::CompiledMethod
  def test_with(parameters, options = {})
    if ENV["TEST"] || TEST
      result = begin
        yield.send name, *parameters
      end
      if result === options[:result]
        print "."
      else
        print "F"
      end
    end
    self
  end
end

class Example
  # The idea here is pretty simple. Define a method, hook off of the return obj
  # and call `test_with`. The `test_with` method takes an array of arguments,
  # a hash of options (result is required), and a block.
  #
  # The block is used to setup the test env, on which the method gets called.
  # Of course you can chain multiple methods, and the same could be done with
  # a class.
  def sample(param1, param2, param3)
   param1 + param2 + param3
  end.
    test_with(["He", "ll", "o!"], :result => "Hello!") { Example.new }.
    test_with ["w","o"], :result => "world" do
      Example.new
    end
end

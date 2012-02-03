class Rubinius::CompiledMethod
  def test(assertion, options = {})
    if ENV["TEST"]
      print "Tested that #{name} #{assertion}"
      if yield == true then 
        puts ", and it worked" 
      else 
        puts ", and it didn't work" 
      end
    end
  end
end



class Example
  def sample(param1, param2, param3)
   param1 + param2 + param3
  end.test "returns the 3 strings combined" do
    object = Example.new
    object.sample("He", "l", "lo") == "Hello"
  end
end

variable = Example.new

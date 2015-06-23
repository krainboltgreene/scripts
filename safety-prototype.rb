require "method_source"

module Safe
  def safely(name, contract)
    target_method = method(name)

  end
end

include Safe

def add(a, b)
  a + b
end
safely :add, %{
  takes: Integer, Integer
  returns: Integer
}



def slice(keys)
  keys.map do |key|
    @attributes.fetch(keys)
  end
end
safely :add, %{
  takes: [Symbol | String]
  returns: Integer
}

add = lambda { |a, b|
  a + b
}

subtract = lambda { |a, b|
  a - b
}

def process(a, b, function)
  function.call(a, b)
end

process(2, 4, add)
process(2, 4, subract)

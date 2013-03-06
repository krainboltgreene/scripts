add = lambda { |a, b|
  a + b
}

subtract = lambda { |a, b|
  a - b
}

def process(a, b, function)
  function.call(a, b)
end

puts process 2, 4, add

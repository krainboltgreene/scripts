(1..100).map do |i|
  x = ''
  x += 'Fizz' if i % 3 == 0
  x += 'Buzz' if i % 5 == 0
  if x.empty? then puts i else puts x end
end

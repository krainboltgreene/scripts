require 'benchmark'
module Enumerable
  def uniq_by
    map do |item|
      { yield(item) => item }
    end.inject do |memo, item|
      unless memo[item.keys.first] then memo.merge item else memo end
    end.values
  end

  def uniq_by2
    r, s = [], {}
    each do |e|
      v = yield(e)
      next if s[v]
      r << e
      s[v] = true
    end
    r
  end
end

@enumerable = (1..500000).map { |i| { id: i, name: ["Kurtis", "James", "Tony"].sample } }

time = Benchmark.realtime do
  @enumerable.uniq_by { |e| e[:name] }
end

time2 = Benchmark.realtime do
  @enumerable.uniq_by2 { |e| e[:name] }
end

puts "Time #{time}ms"

puts "Time #{time2}ms"
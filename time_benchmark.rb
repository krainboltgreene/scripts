require "benchmark/ips"
require "date"

Benchmark.ips do |analysis|
  analysis.time = 5
  analysis.warmup = 2

  analysis.report("a string") do
    "2014-09-23 22:42:04 -0500"
  end

  analysis.report("date object")do
    Date.parse("2014-09-23 22:42:04 -0500")
  end

  analysis.compare!
end

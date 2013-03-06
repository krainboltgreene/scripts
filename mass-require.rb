require 'benchmark/ips'

Benchmark.ips do |run|
  run.report("using block") { ['pp', 'ostruct', 'optparse'].each { |l| require l } }
  run.report("using symbol-block") { ['pp', 'ostruct', 'optparse'].each &method(:require) }
end

require "benchmark/ips"
require "json"
require "oj"
require "yajl"
require "yajl/version"

puts "OS Name: #{`uname -a`}"
puts `sw_vers`
puts "Ruby Version: #{`ruby -v`}"
puts "RubyGems Version: #{`gem -v`}"
puts "RVM Version: #{`rvm -v`}"
puts "oj.gem Version: #{Oj::VERSION}"
puts "yajl-ruby.gem Version: #{Yajl::VERSION}"

SMALL_LOAD = %|{"a":"1", "b": 2, "c": { "z": "9", "x": 10 }, "d": ["a", 1, {}, []]}|
SMALL_DUMP = {"a" => "1", "b" => 2, "c" => { "z" => "9", "x" => 10 }, "d" => ["a", 1, {}, []]}

Benchmark.ips do |analysis|
  analysis.time = 5
  analysis.warmup = 2

  analysis.report("stdlib small load") do
    JSON.load(SMALL_LOAD.dup)
  end

  analysis.report("oj small load")do
    Oj.load(SMALL_LOAD.dup)
  end

  analysis.report("yajl small load")do
    Yajl::Parser.new.parse(SMALL_LOAD.dup)
  end

  analysis.compare!
end

Benchmark.ips do |analysis|
  analysis.time = 5
  analysis.warmup = 2

  analysis.report("stdlib small dump") do
    JSON.dump(SMALL_DUMP.dup)
  end

  analysis.report("oj small dump")do
    Oj.dump(SMALL_DUMP.dup)
  end

  analysis.report("yajl small dump")do
    Yajl::Encoder.new.encode(SMALL_DUMP.dup)
  end

  analysis.compare!
end

BIG_LOAD = File.read("big.json")
BIG_DUMP = Marshal.load(File.read("big.json.rb"))

Benchmark.ips do |analysis|
  analysis.time = 5
  analysis.warmup = 2

  analysis.report("stdlib big load") do
    JSON.load(BIG_LOAD.dup)
  end

  analysis.report("oj big load")do
    Oj.load(BIG_LOAD.dup)
  end

  analysis.report("yajl big load")do
    Yajl::Parser.new.parse(BIG_LOAD.dup)
  end

  analysis.compare!
end

Benchmark.ips do |analysis|
  analysis.time = 5
  analysis.warmup = 2

  analysis.report("stdlib big dump") do
    JSON.dump(BIG_DUMP.dup)
  end

  analysis.report("oj big dump")do
    Oj.dump(BIG_DUMP.dup)
  end

  analysis.report("yajl big dump")do
    Yajl::Encoder.new.encode(BIG_DUMP.dup)
  end

  analysis.compare!
end

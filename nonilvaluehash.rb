require "benchmark/ips"

puts "OS Name: #{`uname -a`}"
puts `sw_vers`
puts "Ruby Version: #{`ruby -v`}"
puts "RubyGems Version: #{`gem -v`}"
puts "RVM Version: #{`rvm -v`}"

Benchmark.ips do |analysis|
  analysis.time = 5
  analysis.warmup = 2

  analysis.report("tap small load") do
    {}.tap do |hash|
      hash.store("a",1) if (1 % 2).zero?
      hash.store("b",2) if (2 % 2).zero?
      hash.store("c",3) if (3 % 2).zero?
      hash.store("d",4) if (4 % 2).zero?
      hash.store("e",5) if (5 % 2).zero?
      hash.store("f",6) if (6 % 2).zero?
      hash.store("g",7) if (7 % 2).zero?
      hash.store("h",8) if (8 % 2).zero?
      hash.store("i",9) if (9 % 2).zero?
    end
  end

  analysis.report("select small load")do
    {
      "a" => 1,
      "b" => 2,
      "c" => 3,
      "d" => 4,
      "e" => 5,
      "f" => 6,
      "g" => 7,
      "h" => 8,
      "i" => 9
    }.select { |key, value| (value % 2).zero? }
  end

  analysis.compare!
end

Benchmark.ips do |analysis|
  analysis.time = 5
  analysis.warmup = 2

  analysis.report("tap large dump") do
    {}.tap do |hash|
      hash.store("a",1) if (1 % 2).zero?
      hash.store("b",2) if (2 % 2).zero?
      hash.store("c",3) if (3 % 2).zero?
      hash.store("d",4) if (4 % 2).zero?
      hash.store("e",5) if (5 % 2).zero?
      hash.store("f",6) if (6 % 2).zero?
      hash.store("g",7) if (7 % 2).zero?
      hash.store("h",8) if (8 % 2).zero?
      hash.store("i",9) if (9 % 2).zero?
      hash.store("j",10) if (10 % 2).zero?
      hash.store("k",11) if (11 % 2).zero?
      hash.store("l",12) if (12 % 2).zero?
      hash.store("m",13) if (13 % 2).zero?
      hash.store("n",14) if (14 % 2).zero?
      hash.store("o",15) if (15 % 2).zero?
      hash.store("p",16) if (16 % 2).zero?
      hash.store("q",17) if (17 % 2).zero?
      hash.store("r",18) if (18 % 2).zero?
      hash.store("s",19) if (19 % 2).zero?
      hash.store("t",20) if (20 % 2).zero?
      hash.store("u",21) if (21 % 2).zero?
      hash.store("v",22) if (22 % 2).zero?
      hash.store("w",23) if (23 % 2).zero?
      hash.store("x",24) if (24 % 2).zero?
      hash.store("y",25) if (25 % 2).zero?
      hash.store("z",26) if (26 % 2).zero?
    end
  end

  analysis.report("select large dump") do
    {
      "a" => 1,
      "b" => 2,
      "c" => 3,
      "d" => 4,
      "e" => 5,
      "f" => 6,
      "g" => 7,
      "h" => 8,
      "i" => 9,
      "j" => 10,
      "k" => 11,
      "l" => 12,
      "m" => 13,
      "n" => 14,
      "o" => 15,
      "p" => 16,
      "q" => 17,
      "r" => 18,
      "s" => 19,
      "t" => 20,
      "u" => 21,
      "v" => 22,
      "w" => 23,
      "x" => 24,
      "y" => 25,
      "z" => 26
    }.select { |key, value| (value % 2).zero? }
  end

  analysis.compare!
end

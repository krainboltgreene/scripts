require "benchmark/ips"

puts "OS Name: #{`uname -a`}"
puts `sw_vers`
puts "Ruby Version: #{`ruby -v`}"
puts "RubyGems Version: #{`gem -v`}"
puts "RVM Version: #{`rvm -v`}"

SMALL = (1..100).to_a
BIG = (1..100000).to_a

Benchmark.ips do |analysis|
  analysis.time = 5
  analysis.warmup = 2

  analysis.report("for loop small") do
    for i in SMALL.dup
      i + i
    end
  end

  analysis.report("Enumerable#each small")do
    SMALL.dup.each do |i|
      i + i
    end
  end

  analysis.compare!
end

Benchmark.ips do |analysis|
  analysis.time = 5
  analysis.warmup = 2

  analysis.report("for loop big") do
    for i in BIG.dup
      i + i
    end
  end

  analysis.report("Enumerable#each big")do
    BIG.dup.each do |i|
      i + i
    end
  end

  analysis.compare!
end

# OS Name: Darwin macbookpro.local 13.4.0 Darwin Kernel Version 13.4.0: Sun Aug 17 19:50:11 PDT 2014; root:xnu-2422.115.4~1/RELEASE_X86_64 x86_64
# ProductName:	Mac OS X
# ProductVersion:	10.9.5
# BuildVersion:	13F34
# Ruby Version: ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-darwin13.0]
# RubyGems Version: 2.2.2
# RVM Version: rvm 1.25.33 (stable) by Wayne E. Seguin <wayneeseguin@gmail.com>, Michal Papis <mpapis@gmail.com> [https://rvm.io/]
# Calculating -------------------------------------
#       for loop small     10733 i/100ms
# Enumerable#each small
#                          12141 i/100ms
# -------------------------------------------------
#       for loop small   129664.5 (±4.9%) i/s -     654713 in   5.062374s
# Enumerable#each small
#                        134361.5 (±5.5%) i/s -     679896 in   5.077474s
#
# Comparison:
# Enumerable#each small:   134361.5 i/s
#       for loop small:   129664.5 i/s - 1.04x slower
#
# Calculating -------------------------------------
#         for loop big        14 i/100ms
#  Enumerable#each big        14 i/100ms
# -------------------------------------------------
#         for loop big      147.7 (±3.4%) i/s -        742 in   5.029427s
#  Enumerable#each big      152.0 (±5.9%) i/s -        770 in   5.085293s
#
# Comparison:
#  Enumerable#each big:      152.0 i/s
#         for loop big:      147.7 i/s - 1.03x slower

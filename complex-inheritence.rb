require "benchmark"

module A
  def foo
    42
  end
end

module B; end

module A2; include A; end

module B2; include B; end

module AB; include A; include B; end

module A2B2; include A2; include B2; end

module AA2BB2; include AB; include A2B2; end

class Bar
  include AA2BB2
end

bar = Bar.new
TESTS = 10_000
Benchmark.bmbm do |results|
  results.report("foo") { bar.foo }
end

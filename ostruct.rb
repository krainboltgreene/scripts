require 'benchmark'

class ArgsNode
  attr_accessor :pre
end

class Pre
  attr_accessor :child_nodes
end

class MultipleAsgn19Node
end

class MultipleAsgn18Node
end

class ANode < MultipleAsgn19Node
end

class BNode < MultipleAsgn18Node
  def name
    self.class.name
  end
end

pre = Pre.new
args_node = ArgsNode.new
nodes = [ANode.new, ANode.new, BNode.new] * 100
pre.child_nodes = nodes
args_node.pre = pre


report = Benchmark.bmbm do |x|
  x.report("old") { 1000.times {
    @args_ary = []
    required_pre = args_node.pre
    if required_pre
      for req_pre_arg in required_pre.child_nodes
        if req_pre_arg.kind_of? MultipleAsgn19Node
          @args_ary << [:req]
        else
          @args_ary << [:req, req_pre_arg ? req_pre_arg.name.intern : nil]
        end
      end
    end
  } }

  x.report("new") { 1000.times {
    @nargs_ary = []
    args_node.pre.child_nodes.each do |node|
      node_itern = node.name.intern unless node.kind_of? MultipleAsgn19Node
      @nargs_ary << [:req]
      @nargs_ary.last << node_itern if node_itern
    end if args_node.pre
  } }
end

puts "New is same as old? #{@args_ary == @nargs_ary}"
puts "New is #{report.map(&:to_s).map(&:split).map(&:last).map(&:to_f).inject(:/) * 100 - 100}% faster"

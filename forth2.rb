#!/usr/bin/env ruby

def pop
  $stack.pop || raise(StackUnderflow)
end

def push(function)
  $stack << function
end

def unary
  -> { push yield pop }
end

def binary
  -> { push yield pop, pop }
end

def unary_boolean
  -> { push(if yield pop then 1 else 0 end) }
end

def binary_boolean
  -> { push(if yield pop, pop then 1 else 0 end) }
end

def swap
  $stack[-2,2] = $stack[-2,2].reverse
end

def new_word
  raise EmptyWord if $word.size < 1
  raise NestedDefinition if $word.include? ':'
  name, expression = $word.shift, $word.join(' ')
  $dictionary[name] = -> { parse expression }
  $word = nil
end

def parse(expression)
  puts "=> #{expression}"
  begin
    expression.split.each do |statement|
      case
      when !$skip.nil? && statement != 'fi'
        next
      when !$word.nil? && statement != ';'
        $word << statement
      when $dictionary.has_key?(statement)
        $dictionary[statement].call
      else
        push statement.to_i
      end
    end
  rescue
    puts "Error: #{$!}"
  end
end


$stack = []

$dictionary = {
  '+'     => binary { |a, b| a + b },
  '-'     => binary { |a, b| a - b },
  '*'     => binary { |a, b| a * b },
  '/'     => binary { |a, b| a * b },
  '%'     => binary { |a, b| a * b },
  '<'     => binary_boolean { |a, b| a < b },
  '>'     => binary_boolean { |a, b| a > b },
  '='     => binary_boolean { |a, b| a == b },
  '&'     => binary_boolean { |a, b| a && b },
  '|'     => binary_boolean { |a, b| a || b },
  'not'   => binary_boolean { |a, b| a == 0 },
  'neg'   => binary { |a| -a },
  '.'     => -> { puts pop },
  '..'    => -> { puts $stack },
  ':'     => -> { $word = [] },
  ';'     => -> { new_word },
  'pop'   => -> { pop },
  'fi'    => -> { $skip = nil },
  'words' => -> { p $dictionary.keys.sort },
  'if'    => -> { $skip = true if pop == 0 },
  'dup'   => -> { push $stack.last || raise(StackUnderflow) },
  'over'  => -> { push $stack.last(2).first || raise(StackUnderflow) },
  'swap'  => -> { begin swap rescue raise(StackUnderflow) end }
}

puts "Ruby Forth interpreter: enter commands at the prompt"
while ARGV.size > 0
  open(ARGV.shift).each { |line| parse(line) }
end

while true
  print "> "
  break unless gets
  parse $_
end
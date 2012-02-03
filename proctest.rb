add = ->(number, &block) { puts instance_eval(&block) + number }
add.call(4) { 4 } # => 8


sub = ->(number) { puts yield - number }
sub.call(10) { 2 } # => no block given (yield) (LocalJumpError)


multi = ->(number, &block) { puts instance_eval(&block) * number }
multi[2] { 4 } # => syntax error, unexpected tLBRACE_ARG, expecting $end
                  # multi[2] { 4 }
                  #           ^


div = ->(number, &block) { puts instance_eval(&block) / number }
div[8, ->{2}] # => wrong number of arguments (2 for 1) (ArgumentError)

package :rubies do
  description "Rubies"
  requires :ruby

  verify do
    has_executable "rvm"
    has_executable "ruby"
  end
end

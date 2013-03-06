package :globals do
  description "Global gems that are important"
  gem 'pry'
  gem 'pry-doc'
  gem 'letters'
  requires :ruby

  verify do
    has_gem "pry"
    has_gem "pry-doc"
    has_gem "letters"
  end
end

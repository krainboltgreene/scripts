require "sinatra"
require "pry"

post "/" do
  binding.pry
  puts request.body.to_s
end

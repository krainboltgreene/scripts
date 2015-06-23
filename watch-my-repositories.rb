require "octokit"
stack = Faraday::RackBuilder.new do |builder|
  builder.response :logger
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Octokit.middleware = stack
print "Enter username & password: "
username, password = gets.chomp.split
puts "\n"
client = Octokit::Client.new(login: username, password: password)
print "Token: "
headers = { headers: { "X-GitHub-OTP" => gets.chomp } }
client.user(username, headers)
client.login

client.repositories(headers).each do |repository|
  puts "Watching #{repository.name}"
  client.watch(repository)
end
# krainboltgreene pek-peg-ceem-ry-we-hof-ob-on-

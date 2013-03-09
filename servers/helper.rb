USERNAME = ENV["USERNAME"] || "root"
PASSWORD = ENV["PASSWORD"] || raise("Need a password")
ASSETS = Pathname.new(ENV["ASSETS_PATH"] || "assets").expand_path
NAME = ENV["NAME"] || "Kurtis Rainbolt-Greene"
EMAIL = ENV["EMAIL"] || "me@kurtisrainboltgreene.name"

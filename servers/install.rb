require Pathname.new("helper").expand_path

Dir["packages/**/*"].each { |file| require Pathname.new(file).expand_path }

policy :server, roles: :linode do
  requires :utilities
  requires :applications
  requires :server
  requires :postgresql
  requires :redis
end

deployment do
  delivery :ssh do
    user USERNAME
    password PASSWORD
    roles linode: "74.207.249.226"
  end
end

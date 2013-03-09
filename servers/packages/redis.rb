package :redis, provides: :database do
  requires :essentials
  version "2.6.10"

  source "http://redis.googlecode.com/files/redis-#{version}.tar.gz" do
    pre :install,  "sudo stop redis || true"
    custom_install "make PREFIX=/etc/redis install"
    post :install, "ln -nfs /etc/redis/bin/* /usr/bin/"
  end

  transfer "#{ASSETS}/redis-config.conf", "/tmp/redis-config.conf" do
    post :install, "mv /tmp/redis-config.conf /etc/redis/redis.conf"
  end

  transfer "#{ASSETS}/redis.conf", "/tmp/redis.conf" do
    post :install, "mv /tmp/redis.conf /etc/init/redis.conf"
    post :install, "sudo start redis || sudo restart redis || true"
  end

  verify do
    executables = %w[redis-benchmark redis-check-aof redis-check-dump redis-cli redis-server]
    executables.each do |executable|
      has_executable executable
    end
  end
end

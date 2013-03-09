package :nginx, provides: :server do
  requires :essentials
  version "1.3.9"

  source "http://nginx.org/download/nginx-#{version}.tar.gz" do
    prefix "/etc/nginx"
    with ["http_ssl_module"]
    post :install, "ln -nfs /etc/nginx/sbin/nginx /usr/bin/"
  end

  transfer "#{ASSETS}/nginx.conf", "/tmp/nginx.conf" do
    post :install, "mv /tmp/nginx.conf /etc/init/nginx.conf"
    post :install, "sudo start nginx || sudo restart nginx || true"
  end

  verify do
    has_executable "nginx"
  end
end

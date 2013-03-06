package :ruby do
  description 'Ruby Virtual Machine'
  version '1.9.3'
  runner "rvm install #{version} --patch railsexpress --enable-gcdebug" do
    post :instal, "rvm alias create mri 1.9.3"
    post :instal, "rvm --default 1.9.3"
  end
  requires :rvm

  verify do
    has_file '/home/#{ENV["USERNAME"]}/.rvm/bin/ruby-1.9.3-p392'
  end
end

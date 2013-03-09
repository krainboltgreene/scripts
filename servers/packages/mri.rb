package :mri, provides: :ruby do
  description "Ruby Virtual Machine"
  requires :rvm
  version "1.9.3"

  runner "rvm install #{version} --patch railsexpress --enable-gcdebug" do
    post :install, "rvm alias create mri 1.9.3"
    post :install, "rvm --default 1.9.3"
    post :install, "rvm use mri@global"
    post :install, "gem install pry pry-doc letters"
    post :install, "rvm use mri"
  end

  verify do
    has_file "/home/#{USERNAME}/.rvm/bin/ruby-1.9.3-p392"
    has_executable "ruby"
    has_gem "pry"
    has_gem "pry-doc"
    has_gem "letters"
  end
end

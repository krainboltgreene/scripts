package :rvm do
  description "Ruby Virtual Machine Installer"
  requires :utilities

  runner "curl -L https://get.rvm.io | bash -s stable"

  verify do
    has_directory "/home/#{USERNAME}/.rvm/"
  end
end

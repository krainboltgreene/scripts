package :git, provides: :scm do
  description "git version control system"

  apt "git-core" do
    post :install, %|git config --global user.name "Kurtis Rai"|
    post :install, %|git config --global user.email "#{email}"|
  end

  verify do
    has_apt "git-core"
  end
end

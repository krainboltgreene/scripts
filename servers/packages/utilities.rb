package :utilities, provides: :tools do
  description "Various tools that are good to use"
  requires :essentials
  requires :scm

  utilities = %w[curl htop tree rsync vim imagemagick]
  nonbinaries = %w[psmisc openssl imagemagick siege]

  apt utilities + nonbinaries

  verify do
     (utilities - nonbinaries).each do |executable|
      has_apt executable
    end
  end
end

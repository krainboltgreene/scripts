package :essentials do
  description "GCC compiler toolchain for Debian and Ubuntu"
  requires :update

  essentials = %w[
    build-essential
    zlib1g-dev
    libssl-dev
    libpcre3-dev
    libreadline6-dev
    libcurl4-openssl-dev
    autotools-dev
    libpq-dev
  ]

  apt essentials

  verify do
    essentials.each do |package|
      has_apt package
    end
  end
end


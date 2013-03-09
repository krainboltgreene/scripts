package :postgresql, provides: :database do
  requires :essentials
  version "9.2.3"

  source "http://ftp.postgresql.org/pub/source/v#{version}/postgresql-#{version}.tar.gz" do
    prefix "/etc/postgresql"
    with %w[perl openssl]
    post :install, "useradd -m -s /bin/bash postgres || true"
    post :install, "ln -nfs /etc/postgresql/bin/* /usr/bin"
    post :install, "mkdir -p /usr/local/pgsql/data"
    post :install, "chown -R postgres /usr/local/pgsql"
    post :install, "su - postgres -c \"/etc/postgresql/bin/initdb -D /usr/local/pgsql/data --encoding=UTF8 --locale=en_US.UTF8\" || true"
  end

  transfer "#{ASSETS}/postgresql.conf", "/tmp/postgresql.conf" do
    post :install, "mv /tmp/postgresql.conf /etc/init/postgresql.conf"
    post :install, "sudo restart postgresql || sudo start postgresql || true"
    post :install, "sleep 5; sudo su - postgres -c \"/etc/postgresql/bin/createuser deployer --createdb --no-createrole --no-superuser\" || true"
  end

  verify do
    executables = %w[clusterdb createdb createlang createuser dropdb droplang dropuser ecpg
      initdb pg_basebackup pg_config pg_controldata pg_ctl pg_dump pg_dumpall pg_resetxlog
      pg_restore postgres psql reindexdb vacuumdb]

    executables.each do |executable|
      has_executable executable
    end
  end
end

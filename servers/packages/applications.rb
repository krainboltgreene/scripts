package :applications do
  noop do
    pre :install, "mkdir /srv/applications"
    pre :install, "chown root /srv/applications"
    pre :install, "chgrp root /srv/applications"
    pre :install, "chmod 755 /srv/applications"
  end

  verify do
    has_directory "/srv/applications/"
  end
end

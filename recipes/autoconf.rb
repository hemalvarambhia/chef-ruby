
autoconf_version = "2.69"
autoconf_tarball = "autoconf-#{autoconf_version}.tar.gz"
remote_file autoconf_tarball do
  source "http://ftp.gnu.org/gnu/autoconf/#{autoconf_tarball}"
  action :create
end
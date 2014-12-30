rubygems_version = "1.8.24"
rubygems_source_tarball = "rubygems-#{rubygems_version}.tgz"
remote_file rubygems_source_tarball do
  source "http://production.cf.rubygems.org/rubygems/#{rubygems_source_tarball}"
  action :create
end
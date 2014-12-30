rubygems_source_tarball = "rubygems-#{node[:ruby][:rubygems_version]}.tgz"
remote_file rubygems_source_tarball do
  source "http://production.cf.rubygems.org/rubygems/#{rubygems_source_tarball}"
  action :create
end

execute("untar-rubygems-tarball") do
  command "tar -zxf #{rubygems_source_tarball} -C #{node[:ruby][:installation_dir]}/src"
  action :run
end

execute("compile-rubygems-#{node[:ruby][:rubygems_version]}") do
  cwd "#{node[:ruby][:installation_dir]}/src/rubygems-#{node[:ruby][:rubygems_version]}"
  command "#{node[:ruby][:installation_dir]}/bin/ruby setup.rb"
  action :run
end
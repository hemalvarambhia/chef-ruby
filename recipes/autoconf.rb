Chef::Resource::RemoteFile.send(:include, ChefRuby::AutoconfHelper)
Chef::Resource::Execute.send(:include, ChefRuby::AutoconfHelper)

autoconf_version = "2.69"
autoconf_tarball = "autoconf-#{autoconf_version}.tar.gz"
remote_file autoconf_tarball do
  source "http://ftp.gnu.org/gnu/autoconf/#{autoconf_tarball}"
  not_if { autoconf_already_installed?(autoconf_version) }
  action :create
end

execute "untar-#{autoconf_tarball}" do
  command "tar -xzf #{autoconf_tarball} -C #{node[:ruby][:src_dir]}"
  not_if { autoconf_already_installed?(autoconf_version) }
  action :run
end

execute 'build-autoconf' do
  cwd "#{node[:ruby][:src_dir]}/autoconf-#{autoconf_version}"
  command './configure --prefix=/usr && make && make install'
  not_if { autoconf_already_installed?(autoconf_version) }
  action :run
end

file autoconf_tarball do
  action :delete
end
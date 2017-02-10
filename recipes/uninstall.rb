execute("uninstall-ruby-#{node[:ruby][:uninstall][:version]}") do
  cwd "#{node[:ruby][:src_dir]}/ruby-#{node[:ruby][:uninstall][:version]}"
  command 'sudo make uninstall'
  action :run
end

directory"#{node[:ruby][:src_dir]}/ruby-#{node[:ruby][:uninstall][:version]}" do
  action :delete
  recursive true
end